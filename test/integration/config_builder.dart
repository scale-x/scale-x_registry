import 'dart:io';

import 'package:scale_x_registry/config/entities/config_entity.dart';
import 'package:scale_x_registry/config/entities/sqlite_config_entity.dart';

ConfigEntity getConfig() {
  final storageType = Platform.environment['STORAGE_TYPE'] ?? 'sqlite';
  switch (storageType) {
    case 'sqlite':
      final sqliteConfig = SqliteConfigEntity(inMemory: true);
      return ConfigEntity(sqlite: sqliteConfig);
    default:
      throw Exception("Cant build config entity");
  }
}
