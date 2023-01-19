import 'package:scale_x_registry/config/entities/config_entity.dart';

abstract class ConfigFactory {
  Future<ConfigEntity> getConfig();
}
