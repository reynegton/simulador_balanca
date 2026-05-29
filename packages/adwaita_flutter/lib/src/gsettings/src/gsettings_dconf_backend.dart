import 'package:adwaita_flutter/src/gsettings/src/dconf_client.dart';
import 'package:adwaita_flutter/src/gsettings/src/gsettings_backend.dart';
import 'package:dbus/dbus.dart';

/// GSettings backend that reads/writes values in DConf
class GSettingsDConfBackend implements GSettingsBackend {
  GSettingsDConfBackend({DBusClient? systemBus, DBusClient? sessionBus})
      : _dconfClient =
            DConfClient(systemBus: systemBus, sessionBus: sessionBus);
  // Client for communicating with DConf.
  final DConfClient _dconfClient;

  @override
  Stream<List<String>> get valuesChanged => _dconfClient.notify.map(
        (event) => event.paths.isEmpty
            ? [event.prefix]
            : event.paths.map((path) => event.prefix + path).toList(),
      );

  @override
  Future<DBusValue?> get(String path, DBusSignature signature) async {
    return _dconfClient.read(path);
  }

  @override
  Future<void> set(Map<String, DBusValue?> values) async {
    await _dconfClient.write(values.map(MapEntry.new));
  }

  @override
  Future<void> close() async {
    await _dconfClient.close();
  }
}
