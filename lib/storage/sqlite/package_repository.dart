import 'package:scale_x_registry/exceptions/storage_exception.dart';
import 'package:scale_x_registry/storage/entities/package_entity.dart';
import 'package:scale_x_registry/storage/interfaces/package_repository.dart';
import 'package:sqlite3/sqlite3.dart';

class PackageRepositoryImpl implements PackageRepository {
  Database db;

  PackageRepositoryImpl(this.db);

  @override
  Future<PackageEntity> create(
      {String namespace = "common",
      required String name,
      required int ownerId}) async {
    try {
      db.execute("""
        INSERT INTO packages (namespace, name, owner_id) VALUES (?, ?, ?)
      """, [namespace, name, ownerId]);
      return PackageEntity(
          id: db.lastInsertRowId,
          namespace: namespace,
          name: name,
          ownerId: ownerId);
    } catch (e) {
      throw StorageException(
          "Cant not create package entity: name - $name, ownerId - $ownerId (${e.toString()})");
    }
  }

  @override
  Future<void> delete(int id) async {
    try {
      db.execute("""
        DELETE FROM packages WHERE id = ? LIMIT 1
      """, [id]);
      final result = db.select("""
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
      final result = db.select("""
        SELECT id, owner_id, namespace, name FROM owners WHERE id = ?
      """, [id]);
      final row = result.first;
      return PackageEntity(
          id: row['id'],
          ownerId: row['owner_id'],
          name: row['name'],
          namespace: row['namespace']);
    } catch (e) {
      throw StorageException(
          "Cant not select owner entity: id - $id (${e.toString()})");
    }
  }
}
