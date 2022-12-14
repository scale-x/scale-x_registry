import 'package:path/path.dart';
import 'package:scale_x_registry/config/entities/sqlite_config_entity.dart';
import 'package:scale_x_registry/exceptions/storage_exception.dart';
import 'package:scale_x_registry/storage/interfaces/mode_repository.dart';
import 'package:scale_x_registry/storage/interfaces/package_repository.dart';
import 'package:scale_x_registry/storage/interfaces/owner_repository.dart';
import 'package:scale_x_registry/storage/interfaces/storage_factory.dart';
import 'package:scale_x_registry/storage/interfaces/version_repository.dart';
import 'package:scale_x_registry/storage/sqlite/migration_repository.dart';
import 'package:scale_x_registry/storage/sqlite/mode_repository.dart';
import 'package:scale_x_registry/storage/sqlite/owner_repository.dart';
import 'package:scale_x_registry/storage/sqlite/package_repository.dart';
import 'package:scale_x_registry/storage/sqlite/sqlite_migrations.dart';
import 'package:scale_x_registry/storage/sqlite/version_repository.dart';
import 'package:sqlite3/sqlite3.dart';

class SqliteFactory implements StorageFactory {
  final SqliteConfigEntity _config;
  late Database _db;

  SqliteFactory(this._config);

  @override
  OwnerRepository getOwnerRepository() {
    return OwnerRepositoryImpl(_db);
  }

  @override
  PackageRepository getPackageRepository() {
    return PackageRepositoryImpl(_db);
  }

  @override
  ModeRepository getModeRepository() {
    return ModeRepositoryImp(_db);
  }

  @override
  VersionRepository getVersionRepository() {
    return VersionRepositoryImp(_db);
  }

  @override
  Future<void> start() async {
    await _setDb();
    await _runMigrations();
  }

  @override
  Future<void> stop() async {
    _db.dispose();
  }

  Future<void> _setDb() async {
    if (_config.inMemory == true) {
      _db = sqlite3.openInMemory();
      return;
    }

    final path = _config.path;
    final name = _config.name;

    if (name != null && path != null) {
      _db = sqlite3.open(join(path, name));
      return;
    }

    throw StorageException("Can't get Sqlite database connection");
  }

  Future<void> _runMigrations() async {
    final repository = MigrationRepository(_db);
    final lastExecutedMigration = await repository.getLast();
    final lastAvailableMigration = migrations
        .map((migration) => migration.key)
        .reduce((value, nr) => value > nr ? value : nr);
    if (lastAvailableMigration > lastExecutedMigration) {
      final restMigrations = migrations
          .where((migration) => migration.key > lastExecutedMigration);
      for (final migration in restMigrations) {
        await repository.execute(migration);
      }
    }
  }
}
