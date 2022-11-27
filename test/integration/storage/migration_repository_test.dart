import 'package:scale_x_registry/storage/sqlite/migration_repository.dart';
import 'package:scale_x_registry/storage/sqlite/sqlite_migrations.dart';
import 'package:sqlite3/sqlite3.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

void main() async {
  group('SqliteService', () {
    late Database db;
    late MigrationRepository repository;

    setUpAll(() {
      db = sqlite3.openInMemory();
      repository = MigrationRepository(db);
    });

    tearDownAll(() async {
      db.dispose();
    });

    group('getLast', () {
      test('returns 0 if no database migration given', () async {
        final lastMigrationNr = await repository.getLast();
        expect(lastMigrationNr, 0);
      });

      test('returns 1 after first migration', () async {
        final initMigration = migrations.first;
        await repository.execute(initMigration);
        final lastMigrationNr = await repository.getLast();
        expect(lastMigrationNr, 1);
      });
    });
  }, tags: ['integration']);
}
