import 'package:scale_x_registry/storage/interfaces/storage_service.dart';
import 'package:scale_x_registry/storage/sqlite/migration_repository.dart';
import 'package:scale_x_registry/storage/sqlite/sqlite_migrations.dart';

class SqliteService implements StorageService {
  final MigrationRepository _repository;

  SqliteService(this._repository);
  //  {
  //   final dbPath = join(config.path, config.name);
  //   _db = sqlite3.open(dbPath);
  //   _repository = MigrationRepository(_db);
  // }

  @override
  Future<void> start() async {
    await _runMigrations();
  }

  Future<void> _runMigrations() async {
    final lastExecutedMigration = await _repository.getLast();
    final lastAvailableMigration = migrations
        .map((migration) => migration.key)
        .reduce((value, nr) => value > nr ? value : nr);
    if (lastAvailableMigration > lastExecutedMigration) {
      final restMigrations = migrations
          .where((migration) => migration.key > lastExecutedMigration);
      for (final migration in restMigrations) {
        await _repository.execute(migration);
      }
    }
  }
}
