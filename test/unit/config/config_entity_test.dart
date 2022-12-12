import 'package:scale_x_registry/config/entities/config_entity.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

void main() {
  group('sqlite', () {
    test('returns default param if no config or env vars given', () {
      final configEntity = ConfigEntity.init(null, null);
      expect(configEntity.sqlite?.name, 'Scalex.db');
    });

    test('returns in memory true if it set', () {
      final configEntity = ConfigEntity.init({
        "sqlite": {"in_memory": true}
      }, null);
      expect(configEntity.sqlite?.inMemory, true);
    });

    test("if in memory set to true all other params are null in any way", () {
      final configEntity = ConfigEntity.init({
        "sqlite": {"in_memory": true, "name": "Sqlite.db", "path": "test/db"}
      }, null);
      expect(configEntity.sqlite?.inMemory, true);
      expect(configEntity.sqlite?.name, null);
      expect(configEntity.sqlite?.path, null);
    });

    test('returns config value if given', () {
      final configEntity = ConfigEntity.init({
        "sqlite": {"name": "test_name", "path": "test_path"}
      }, null);
      expect(configEntity.sqlite?.name, "test_name");
      expect(configEntity.sqlite?.path, "test_path");
    });

    test('returns env value if given in priority to config', () {
      final config = {
        "sqlite": {
          "name": "config_name",
          "path": "config_path",
        }
      };
      final env = {"SQLITE_NAME": "env_name", "SQLITE_PATH": "env_path"};
      final configEntity = ConfigEntity.init(config, env);
      expect(configEntity.sqlite?.name, "env_name");
      expect(configEntity.sqlite?.path, "env_path");
    });
  }, tags: 'unit');
}
