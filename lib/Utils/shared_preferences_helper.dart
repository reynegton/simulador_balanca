import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum EnumKeysSharedPreferences {
  ePesoMinMax,
  eCasasDecimais,
}

class SharedPreferencesHelper {
  static final SharedPreferencesHelper _preferencesHelper =
      SharedPreferencesHelper._internal();

  SharedPreferencesHelper._internal();

  static SharedPreferencesHelper get instance {
    return _preferencesHelper;
  }

  Future<bool> deletePrefs(EnumKeysSharedPreferences nameKey) async {
    try {
      var prefs = await SharedPreferences.getInstance();
      return await prefs.remove(nameKey.toString());
    } on Exception catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    return false;
  }

  Future<List<String>> loadAllKeys() async {
    var prefs = await SharedPreferences.getInstance();
    var retorno = prefs.getKeys().toList();
    return retorno;
  }

  // #region Generico
  Future<bool> savePreferencesGeneric(
      EnumKeysSharedPreferences nameKey, dynamic value) async {
    try {
      var prefs = await SharedPreferences.getInstance();
      if (value is String) {
        return await prefs.setString(nameKey.toString(), value);
      } else if (value is int) {
        return await prefs.setInt(nameKey.toString(), value);
      } else if (value is double) {
        return await prefs.setDouble(nameKey.toString(), value);
      } else if (value is bool) {
        return await prefs.setBool(nameKey.toString(), value);
      } else if (value is List<String>) {
        return await prefs.setStringList(nameKey.toString(), value);
      }
    } on Exception catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    return false;
  }

  Future<dynamic> loadPreferencesGeneric<T>(
      EnumKeysSharedPreferences nameKey) async {
    var prefs = await SharedPreferences.getInstance();
    if (T is String) {
      return prefs.getString(nameKey.toString()) ?? "";
    } else if (T is int) {
      return prefs.getInt(nameKey.toString()) ?? "";
    } else if (T is double) {
      return prefs.getDouble(nameKey.toString()) ?? "";
    } else if (T is bool) {
      return prefs.getBool(nameKey.toString()) ?? "";
    } else if (T is List<String>) {
      return prefs.getBool(nameKey.toString()) ?? "";
    }
    return null;
  }
  // #endregion

  // #region String
  Future<bool> saveString(
      EnumKeysSharedPreferences nameKey, String value) async {
    try {
      var prefs = await SharedPreferences.getInstance();
      return await prefs.setString(nameKey.toString(), value);
    } on Exception catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    return false;
  }

  Future<String> loadString(EnumKeysSharedPreferences nameKey) async {
    var prefs = await SharedPreferences.getInstance();
    var response = prefs.getString(nameKey.toString());
    return response ?? "";
  }

  // #endregion
  
  // #region StringList
  Future<bool> saveStringList(
      EnumKeysSharedPreferences nameKey, List<String> value) async {
    try {
      var prefs = await SharedPreferences.getInstance();
      return await prefs.setStringList(nameKey.toString(), value);
    } on Exception catch (_) {
      return false;
    }
  }

  Future<List<String>> loadStringList(EnumKeysSharedPreferences nameKey) async {
    var prefs = await SharedPreferences.getInstance();
    var response = prefs.getStringList(nameKey.toString());
    return response ?? [];
  }

  // #endregion
  
  // #region Boolean
  Future<bool> saveBool(EnumKeysSharedPreferences nameKey, bool value) async {
    try {
      var prefs = await SharedPreferences.getInstance();
      return await prefs.setBool(nameKey.toString(), value);
    } on Exception catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return false;
    }
  }

  Future<bool?> loadBool(EnumKeysSharedPreferences nameKey) async {
    var prefs = await SharedPreferences.getInstance();
    return prefs.getBool(nameKey.toString());
  }

  // #endregion
  
  // #region Integer
  Future<bool> saveInt(EnumKeysSharedPreferences nameKey, int value) async {
    try {
      var prefs = await SharedPreferences.getInstance();
      return await prefs.setInt(nameKey.toString(), value);
    } on Exception catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return false;
    }
  }

  Future<int?> loadInt(EnumKeysSharedPreferences nameKey) async {
    var prefs = await SharedPreferences.getInstance();
    return prefs.getInt(nameKey.toString());
  }

  // #endregion
  
  // #region Double
  Future<bool> saveDouble(
      EnumKeysSharedPreferences nameKey, double value) async {
    try {
      var prefs = await SharedPreferences.getInstance();
      return await prefs.setDouble(nameKey.toString(), value);
    } on Exception catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return false;
    }
  }

  Future<double?> loadDouble(EnumKeysSharedPreferences nameKey) async {
    var prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(nameKey.toString());
  }
  // #endregion
}
