import 'package:scale_x_registry/config/entities/config_entity.dart';

abstract class Config {
  Future<void> init(String configPath);

  ConfigEntity get();
}
