import 'package:scale_x_registry/exceptions/storage_exception.dart';
import 'package:scale_x_registry/storage/entities/package_entity.dart';
import 'package:scale_x_registry/storage/interfaces/package_repository.dart';
import 'package:sqlite3/sqlite3.dart';

class PackageRepositoryImpl implements PackageRepository {
  final Database _db;

  PackageRepositoryImpl(this._db);

  @override
  Future<PackageEntity> create(
      {required String scope,
      required String name,
      required int ownerId}) async {
    try {
      _db.execute("""
        INSERT INTO packages (scope, name, owner_id) VALUES (?, ?, ?)
      """, [scope, name, ownerId]);
      return PackageEntity(
          id: _db.lastInsertRowId, scope: scope, name: name, ownerId: ownerId);
    } catch (e) {
      throw StorageException(
          "Cant not create package entity: name - $name, ownerId - $ownerId (${e.toString()})");
    }
  }

  @override
  Future<void> delete(int id) async {
    try {
      _db.execute("""
        DELETE FROM packages WHERE id = ? LIMIT 1
      """, [id]);
      final result = _db.select("""
        SELECT changes() as deleted;
      """);
      if (result.first["deleted"] != 1) {
        throw StorageException("package entity was not deleted");
      }
    } catch (e) {
      throw StorageException(
          "Cant not delete package: id - $id (${e.toString()})");
    }
  }

  @override
  Future<PackageEntity> getById(int id) async {
    try {
      final result = _db.select("""
        SELECT id, owner_id, scope, name FROM packages WHERE id = ?
      """, [id]);
      final row = result.first;
      return PackageEntity(
          id: row['id'],
          ownerId: row['owner_id'],
          name: row['name'],
          scope: row['scope']);
    } catch (e) {
      throw StorageException(
          "Cant not select owner entity: id - $id (${e.toString()})");
    }
  }

  @override
  Future<PackageEntity> getByScopeAndName(
      {required String scope, required String name}) async {
    try {
      final result = _db.select("""
        SELECT id, owner_id, scope, name FROM packages WHERE scope = ? AND name = ?
      """, [scope, name]);
      final row = result.first;
      return PackageEntity(
          id: row['id'],
          ownerId: row['owner_id'],
          name: row['name'],
          scope: row['scope']);
    } catch (e) {
      throw StorageException(
          "Cant not select owner entity: scope - $scope, name - $name (${e.toString()})");
    }
  }
}
