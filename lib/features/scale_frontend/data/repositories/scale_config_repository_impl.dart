import '../../../../Utils/shared_preferences_helper.dart';
import '../../domain/entities/scale_config.dart';
import '../../domain/repositories/scale_config_repository.dart';

class ScaleConfigRepositoryImpl implements ScaleConfigRepository {
  final SharedPreferencesHelper prefsHelper;

  ScaleConfigRepositoryImpl(this.prefsHelper);

  @override
  Future<ScaleConfig> loadConfig() async {
    final casasDecimais = await prefsHelper.loadInt(EnumKeysSharedPreferences.eCasasDecimais) ?? 1;
    final minMax = await prefsHelper.loadInt(EnumKeysSharedPreferences.ePesoMinMax) ?? 999999;
    
    // We didn't persist port originally, so we default to 9090
    return ScaleConfig(
      port: 9090, 
      minMaxValue: minMax,
      casasDecimais: casasDecimais,
    );
  }

  @override
  Future<void> saveConfig(ScaleConfig config) async {
    await prefsHelper.saveInt(EnumKeysSharedPreferences.eCasasDecimais, config.casasDecimais);
    await prefsHelper.saveInt(EnumKeysSharedPreferences.ePesoMinMax, config.minMaxValue);
  }
}
