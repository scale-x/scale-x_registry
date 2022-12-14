import 'package:scale_x_registry/exceptions/storage_exception.dart';
import 'package:scale_x_registry/storage/entities/mode_entity.dart';
import 'package:scale_x_registry/storage/interfaces/mode_repository.dart';
import 'package:sqlite3/sqlite3.dart';

class ModeRepositoryImp implements ModeRepository {
  Database db;

  ModeRepositoryImp(this.db);

  @override
  Future<ModeEntity> create(
      {required int packageId, required String title}) async {
    try {
      db.execute("""
        INSERT INTO modes (package_id, title) VALUES (?, ?)
      """, [packageId, title]);
      return ModeEntity(
          id: db.lastInsertRowId, packageId: packageId, title: title);
    } catch (e) {
      throw StorageException(
          "Cant not create mode entity: packageId - $packageId, title $title (${e.toString()})");
    }
  }

  @override
  Future<void> delete(int id) async {
    try {
      db.execute("""
        DELETE FROM modes WHERE id = ? LIMIT 1
      """, [id]);
      final result = db.select("""
        SELECT changes() as deleted;
      """);
      if (result.first["deleted"] != 1) {
        throw StorageException("entity was not deleted");
      }
    } catch (e) {
      throw StorageException(
          "Cant not delete mode entity: id - $id (${e.toString()})");
    }
  }

  @override
  Future<ModeEntity> getById(int id) async {
    try {
      final result = db.select("""
        SELECT id, package_id, title FROM modes WHERE id = ?
      """, [id]);
      return ModeEntity(
          id: result.first['id'],
          packageId: result.first['package_id'],
          title: result.first['title']);
    } catch (e) {
      throw StorageException(
          "Cant not select modes entity: id - $id (${e.toString()})");
    }
  }
}
