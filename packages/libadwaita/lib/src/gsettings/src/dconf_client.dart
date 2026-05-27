// ignore_for_file: only_throw_errors, lines_longer_than_80_chars, no_runtimetype_tostring
import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:dbus/dbus.dart';
import 'package:libadwaita/src/gsettings/src/getuid.dart';
import 'package:libadwaita/src/gsettings/src/gvariant_binary_codec.dart';
import 'package:libadwaita/src/gsettings/src/gvariant_database.dart';
import 'package:xdg_directories/xdg_directories.dart';

/// Message received when DConf notifies changes.
class DConfNotifyEvent {
  const DConfNotifyEvent(this.prefix, this.paths, this.tag);

  /// A prefixed applied to each value in [keys].
  final String prefix;

  /// The paths to each key that has changed, to be prefixed with [prefix].
  /// If empty, a single key has changed with the value [prefix].
  final List<String> paths;

  /// Unique tag for this change, used to detect if this client generated the change.
  final String tag;

  @override
  String toString() => "$runtimeType('$prefix', $paths, '$tag')";
}

/// A client that connects to DConf.
class DConfClient {
  /// Creates a new DConf client.
  DConfClient({this.profile, DBusClient? systemBus, DBusClient? sessionBus})
      : _systemBus = systemBus ?? DBusClient.system(),
        _sessionBus = sessionBus ?? DBusClient.session(),
        _closeSessionBus = sessionBus == null,
        _closeSystemBus = systemBus == null {
    _notifyController.onListen = () {
      _loadSources().then((sources) {
        if (sources.isEmpty) {
          throw 'No DConf source to write to';
        }
        _notifyController.addStream(
          DBusRemoteObjectSignalStream(
            object: sources[0].writer,
            interface: 'ca.desrt.dconf.Writer',
            name: 'Notify',
            signature: DBusSignature('sass'),
          ).map(
            (signal) => DConfNotifyEvent(
              signal.values[0].asString(),
              signal.values[1].asStringArray().toList(),
              signal.values[2].asString(),
            ),
          ),
        );
      });
    };
  }
  final String? profile;

  /// Stream of key names that indicate when a value has changed.
  Stream<DConfNotifyEvent> get notify => _notifyController.stream;
  final _notifyController = StreamController<DConfNotifyEvent>.broadcast();

  /// The D-Bus buses this client is connected to.
  final DBusClient _systemBus;
  final DBusClient _sessionBus;
  final bool _closeSystemBus;
  final bool _closeSessionBus;

  /// Gets all the keys available underneath the given directory.
  Future<List<String>> list(String dir) async {
    final sources = await _loadSources();
    final keys = <String>{};
    for (final source in sources) {
      keys.addAll(await source.database.list(dir: dir));
    }
    return keys.toList();
  }

  /// Gets the value of a given [key].
  Future<DBusValue?> read(String key) async {
    final sources = await _loadSources();
    for (final source in sources) {
      final value = await source.database.lookup(key);
      if (value != null) {
        return value;
      }
    }
    return null;
  }

  /// Sets key values in the dconf database.
  Future<String> write(Map<String, DBusValue?> values) async {
    final sources = await _loadSources();
    if (sources.isEmpty) {
      throw 'No DConf source to write to';
    }

    final changeset = DBusDict(
      DBusSignature('s'),
      DBusSignature('mv'),
      values.map(
        (key, value) => MapEntry(
          DBusString(key),
          DBusMaybe(
            DBusSignature('v'),
            value != null ? DBusVariant(value) : null,
          ),
        ),
      ),
    );
    final codec = GVariantBinaryCodec();
    final result = await sources[0].writer.callMethod(
          'ca.desrt.dconf.Writer',
          'Change',
          [DBusArray.byte(codec.encode(changeset, endian: Endian.host))],
          replySignature: DBusSignature('s'),
        );
    return result.values[0].asString();
  }

  /// Terminates the connection to the DConf daemon. If a client remains unclosed, the Dart process may not terminate.
  Future<void> close() async {
    if (_closeSystemBus) {
      await _systemBus.close();
    }
    if (_closeSessionBus) {
      await _sessionBus.close();
    }
  }

  // Load the DConf sources in use.
  Future<List<DConfEngineSource>> _loadSources() async {
    // Generate list of files to look for the profile in.
    final paths = <String>[];
    var profileName = profile;
    if (profileName == null) {
      final uid = getuid();
      paths.add('/run/dconf/user/$uid');
      profileName = Platform.environment['DCONF_PROFILE'];
    }
    if (profileName != null) {
      if (profileName.startsWith('/')) {
        paths.add(profileName);
      } else {
        paths.addAll(_getProfilePaths(profileName));
      }
    } else {
      final rd = runtimeDir;
      if (rd != null) {
        paths.add(_buildFilename([rd.path, 'dconf', 'profile']));
      }
      paths.addAll(_getProfilePaths('user'));
    }

    // Find the first file that exists.
    for (final path in paths) {
      final sources = await _loadProfileFile(path);
      if (sources != null) {
        return sources;
      }
    }

    // Return the default profile.
    if (profileName == null) {
      return [DConfEngineSourceUser('user', _sessionBus)];
    } else {
      return [];
    }
  }

  // Get the paths to find a DConf profile with [profileName].
  List<String> _getProfilePaths(String profileName) {
    final paths = [
      _buildFilename(['/etc', 'dconf', 'profile', profileName]),
    ];
    for (final dir in dataDirs) {
      paths.add(_buildFilename([dir.path, 'dconf', 'profile', profileName]));
    }
    return paths;
  }

  // Load a DConf profile file.
  Future<List<DConfEngineSource>?> _loadProfileFile(String path) async {
    final file = File(path);
    List<String> lines;
    try {
      lines = await file.readAsLines();
    } on FileSystemException {
      return null;
    }

    final sources = <DConfEngineSource>[];
    for (var line in lines) {
      // Strip off comments.
      final commentIndex = line.lastIndexOf('#');
      if (commentIndex >= 0) {
        line = line.substring(0, commentIndex);
      }
      line = line.trim();
      if (line.isEmpty) {
        continue;
      }

      final index = line.indexOf(':');
      if (index < 0) {
        throw "Invalid DConf profile line: '$line'";
      }
      final type = line.substring(0, index);
      final value = line.substring(index + 1);
      DConfEngineSource source;
      switch (type) {
        case 'user-db':
          source = DConfEngineSourceUser(value, _sessionBus);
          break;
        case 'system-db':
          source = DConfEngineSourceSystem(value, _systemBus);
          break;
        case 'service-db': // Not implemented
        case 'file-db': // Not implemented
        default:
          throw "Unknown DConf source: 'line'";
      }
      sources.add(source);
    }

    return sources;
  }
}

class DConfEngineSource {
  /// The database containing configuration.
  GVariantDatabase get database {
    throw 'Not implemented';
  }

  /// D-Bus object to write to configuration.
  DBusRemoteObject get writer {
    throw 'Not implemented';
  }
}

class DConfEngineSourceUser extends DConfEngineSource {
  DConfEngineSourceUser(this.name, this.sessionBus);
  final String name;
  final DBusClient sessionBus;

  @override
  GVariantDatabase get database =>
      GVariantDatabase(_buildFilename([configHome.path, 'dconf', name]));

  @override
  DBusRemoteObject get writer => DBusRemoteObject(
        sessionBus,
        name: 'ca.desrt.dconf',
        path: DBusObjectPath('/ca/desrt/dconf/Writer/$name'),
      );

  @override
  String toString() => "$runtimeType('$name')";
}

class DConfEngineSourceSystem extends DConfEngineSource {
  DConfEngineSourceSystem(this.name, this.systemBus);
  final String name;
  final DBusClient systemBus;

  @override
  GVariantDatabase get database =>
      GVariantDatabase(_buildFilename(['/etc', 'dconf', 'db', name]));

  @override
  DBusRemoteObject get writer => DBusRemoteObject(
        systemBus,
        name: 'ca.desrt.dconf',
        path: DBusObjectPath('/ca/desrt/dconf/Writer/$name'),
      );

  @override
  String toString() => "$runtimeType('$name')";
}

// Build a filename from parts.
String _buildFilename(List<String> parts) {
  var path = parts.join('/');
  while (true) {
    final updatedPath = path.replaceAll('//', '/');
    if (updatedPath == path) {
      return path;
    }
    path = updatedPath;
  }
}
