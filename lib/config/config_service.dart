import 'dart:io';

import 'package:scale_x_registry/config/config_interface.dart';
import 'package:scale_x_registry/config/entities/config_entity.dart';
import 'package:yaml/yaml.dart';

class ConfigService implements Config {
  late ConfigEntity _configEntity;

  @override
  Future<void> init(String configPath) async {
    var configFile = await _readConfigFile(configPath);

    return;
    // Platform.environment['AAA'] = 'BBBB';
    // // TODO: implement init
    // throw UnimplementedError();
  }

  @override
  ConfigEntity get() {
    return _configEntity;
  }

  Future<dynamic> _readConfigFile(String configPath) async {
    try {
      var configFile = await File(configPath).readAsString();
      return loadYaml(configFile);
    } catch (e) {
      return null;
    }
  }
}
