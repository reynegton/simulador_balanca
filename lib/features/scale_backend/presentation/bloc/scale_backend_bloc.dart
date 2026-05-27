import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/repositories/scale_server_repository.dart';
import '../../domain/formatters/protocol_strategy.dart';
import 'scale_backend_event.dart';
import 'scale_backend_state.dart';

class ScaleBackendBloc extends Bloc<ScaleBackendEvent, ScaleBackendState> {
  final ScaleServerRepository repository;
  final ProtocolStrategy protocolStrategy;

  Timer? _timer;
  StreamSubscription? _historySub;
  
  String _currentIp = "";
  int _currentPort = 0;
  List<String> _currentHistory = [];
  
  int _latestPeso = 0;
  int _latestTara = 0;

  ScaleBackendBloc({
    required this.repository,
    required this.protocolStrategy,
  }) : super(ScaleBackendInitial()) {
    on<StartServerEvent>(_onStartServer);
    on<StopServerEvent>(_onStopServer);
    on<EmitWeightEvent>(_onEmitWeight);

    on<UpdateHistoryEvent>(_onUpdateHistory);

    _historySub = repository.protocolHistoryStream.listen((history) {
      add(UpdateHistoryEvent(history));
    });
  }

  Future<void> _onStartServer(StartServerEvent event, Emitter<ScaleBackendState> emit) async {
    emit(ScaleBackendLoading());
    try {
      _currentPort = event.port;
      _currentIp = await repository.startServer(event.port);
      emit(ScaleBackendRunning(_currentIp, _currentPort, _currentHistory));

      _timer?.cancel();
      _timer = Timer.periodic(const Duration(milliseconds: 300), (_) {
        if (!isClosed) {
           var message = protocolStrategy.formatWeight(_latestPeso, _latestTara);
           repository.broadcastMessage(message);
        }
      });
    } catch (e) {
      emit(ScaleBackendError(e.toString()));
    }
  }

  Future<void> _onStopServer(StopServerEvent event, Emitter<ScaleBackendState> emit) async {
    _timer?.cancel();
    await repository.stopServer();
    emit(ScaleBackendInitial());
  }

  void _onUpdateHistory(UpdateHistoryEvent event, Emitter<ScaleBackendState> emit) {
    if (state is ScaleBackendRunning) {
      _currentHistory = event.history;
      emit(ScaleBackendRunning(_currentIp, _currentPort, List.from(event.history)));
    }
  }

  void _onEmitWeight(EmitWeightEvent event, Emitter<ScaleBackendState> emit) {
    _latestPeso = event.peso;
    _latestTara = event.tara;
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    _historySub?.cancel();
    repository.stopServer();
    return super.close();
  }
}
