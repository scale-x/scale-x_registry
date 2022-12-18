import 'package:scale_x_registry/storage/sqlite/sqlite_migrations.dart';
import 'package:sqlite3/sqlite3.dart';

class MigrationRepository {
  final Database _db;

  MigrationRepository(this._db);

  Future<int> getLast() async {
    try {
      final result = _db.select("""
        SELECT MAX(migration) AS last FROM migrations;      
      """);
      return result.last['last'];
    } catch (e) {
      return 0;
    }
  }

  Future<void> execute(Migration migration) async {
    _db
      ..execute(migration.value)
      ..execute("""
        INSERT INTO migrations (migration) VALUES (?);
      """, [migration.key]);
  }
}
