import 'package:scale_x_registry/exceptions/storage_exception.dart';
import 'package:scale_x_registry/storage/entities/version_entity.dart';
import 'package:scale_x_registry/storage/interfaces/version_repository.dart';
import 'package:sqlite3/sqlite3.dart';

class VersionRepositoryImp implements VersionRepository {
  final Database _db;

  VersionRepositoryImp(this._db);

  @override
  Future<VersionEntity> create(
      {required int packageId,
      required int major,
      required int minor,
      required int path,
      String? postfix = ''}) async {
    try {
      _db.execute("""
        INSERT INTO versions (package_id, major, minor, path, postfix) 
        VALUES (?, ?, ?, ?, ?);
      """, [
        packageId,
        major,
        minor,
        path,
        postfix,
      ]);
      return VersionEntity(
          id: _db.lastInsertRowId,
          packageId: packageId,
          major: major,
          minor: minor,
          path: path,
          postfix: postfix == '' ? null : postfix);
    } catch (e) {
      throw StorageException(
          "Cant not create version entity: package_id - $packageId, major - $major, minor - $minor, path - $path, postfix $postfix (${e.toString()})");
    }
  }

  @override
  Future<void> delete(int id) async {
    try {
      _db.execute("""
        DELETE FROM versions WHERE id = ? LIMIT 1
      """, [id]);
      final result = _db.select("""
        SELECT changes() as deleted;
      """);
      if (result.first["deleted"] != 1) {
        throw StorageException("version entity was not deleted");
      }
    } catch (e) {
      throw StorageException(
          "Cant not delete version: id - $id (${e.toString()})");
    }
  }

  @override
  Future<VersionEntity> getById(int id) async {
    try {
      final result = _db.select("""
        SELECT id, package_id, major, minor, path, postfix FROM versions WHERE id = ?;
      """, [id]);
      final row = result.first;
      return VersionEntity(
          id: row['id'],
          packageId: row['package_id'],
          major: row['major'],
          minor: row['minor'],
          path: row['path'],
          postfix: row['postfix'] == '' ? null : row['postfix']);
    } catch (e) {
      throw StorageException(
          "Cant not select owner entity: id - $id (${e.toString()})");
    }
  }
}
