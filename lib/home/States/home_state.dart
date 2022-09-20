abstract class HomeState {}

class HomeStateDisconect extends HomeState {
  HomeStateDisconect({this.messageError,this.protocolos});
  String? messageError;
  List<String>? protocolos;
}

class HomeStateLoading extends HomeState {}

class HomeStateSucess extends HomeState {
  final List<String> protocolos;
  HomeStateSucess(this.protocolos);
}
