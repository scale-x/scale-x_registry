import 'dart:io';

import 'package:path/path.dart';
import 'package:scale_x_registry/config/entities/config_entity.dart';
import 'package:scale_x_registry/config/interfaces/config_factory.dart';
import 'package:yaml/yaml.dart';

class ConfigFactoryImpl implements ConfigFactory {
  final String? _configPath;

  ConfigFactoryImpl(this._configPath);

  @override
  Future<ConfigEntity> getConfig() async {
    var fileConfig = await _readConfigFile();
    return ConfigEntity.init(fileConfig, Platform.environment);
  }

  Future<dynamic> _readConfigFile() async {
    final configPath =
        _configPath ?? join(dirname(Platform.script.path), 'config.yml');
    try {
      final configFile = await File(configPath).readAsString();
      return loadYaml(configFile);
    } catch (e) {
      return {};
    }
  }
}
