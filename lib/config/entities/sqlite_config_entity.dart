import 'dart:io';

import 'package:scale_x_registry/config/config_param.dart';

class SqliteConfigEntity {
  bool? inMemory;
  String? name;
  String? path;

  SqliteConfigEntity({this.inMemory, this.name, this.path});

  static SqliteConfigEntity init(dynamic config, Map<String, dynamic>? env) {
    final configParam =
        ConfigParam(config: config, section: 'sqlite', env: env);

    final inMemory =
        configParam.getBooleanParam("SQLITE_IN_MEMORY", 'in_memory', false);

    if (inMemory == true) {
      return SqliteConfigEntity(inMemory: true);
    }

    final name =
        configParam.getStringParamRequired('SQLITE_NAME', 'name', 'Scalex.db');
    final path = configParam.getStringParamRequired(
        'SQLITE_PATH', 'path', Directory.current.toString());

    return SqliteConfigEntity(name: name, path: path);
  }
}
