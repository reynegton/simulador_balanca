import '../entities/scale_config.dart';

abstract class ScaleConfigRepository {
  Future<ScaleConfig> loadConfig();
  Future<void> saveConfig(ScaleConfig config);
}
