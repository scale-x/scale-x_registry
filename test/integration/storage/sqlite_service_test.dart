import 'package:scale_x_registry/storage/sqlite/migration_repository.dart';
import 'package:scale_x_registry/storage/sqlite/sqlite_service.dart';
import 'package:sqlite3/sqlite3.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

void main() async {
  group("SqliteService", () {
    late Database db;
    late MigrationRepository repository;
    setUpAll(() {
      db = sqlite3.openInMemory();
      repository = MigrationRepository(db);
    });

    tearDownAll(() {
      db.dispose();
    });

    test('runs all migrations on start', () async {
      final sqliteService = SqliteService(repository);
      await sqliteService.start();
      final lastMigration = await repository.getLast();
      expect(lastMigration > 0, true);
    });
  }, tags: ['sqlite']);
}
