import 'dart:async';

import 'package:dbus/dbus.dart';

import 'package:libadwaita/src/gsettings/src/gsettings_backend.dart';

/// GSettings backend that reads/writes values in memory.
class GSettingsMemoryBackend implements GSettingsBackend {
  GSettingsMemoryBackend();

  /// The stored values.
  final _values = <String, DBusValue>{};

  final _valuesChanged = StreamController<List<String>>();

  @override
  Stream<List<String>> get valuesChanged => _valuesChanged.stream;

  @override
  Future<DBusValue?> get(String path, DBusSignature signature) async {
    return _values[path];
  }

  @override
  Future<void> set(Map<String, DBusValue?> values) async {
    for (final entry in values.entries) {
      if (entry.value != null) {
        _values[entry.key] = entry.value!;
      } else {
        _values.remove(entry.key);
      }
    }
  }

  @override
  Future<void> close() async {}
}
