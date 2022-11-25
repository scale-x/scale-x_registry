import 'package:scale_x_registry/config/entities/postgres_config_entity.dart';
import 'package:scale_x_registry/config/entities/sqlite_config_entity.dart';

class ConfigEntity {
  SqliteConfigEntity? sqlite;
  PostgresConfigEntity? postgres;

  ConfigEntity({this.sqlite, this.postgres});

  static ConfigEntity init(dynamic config, Map<String, dynamic>? env) {
    final sqlite = SqliteConfigEntity.init(config, env);
    return ConfigEntity(sqlite: sqlite);
  }
}
