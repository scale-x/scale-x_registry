import 'dart:io';

import 'package:scale_x_registry/config/config_param.dart';

class SqliteConfigEntity {
  String name;
  String path;

  SqliteConfigEntity({required this.name, required this.path});

  static SqliteConfigEntity init(dynamic config, Map<String, dynamic>? env) {
    final configParam =
        ConfigParam(config: config, section: 'sqlite', env: env);
    final name =
        configParam.getStringParamRequired('SQLITE_NAME', 'name', 'Scalex.db');
    final path = configParam.getStringParamRequired(
        'SQLITE_PATH', 'path', Directory.current.toString());

    return SqliteConfigEntity(name: name, path: path);
  }
}
