import 'package:scale_x_registry/exceptions/storage_exception.dart';
import 'package:scale_x_registry/storage/entities/package_entity.dart';
import 'package:scale_x_registry/storage/interfaces/package_repository.dart';
import 'package:sqlite3/sqlite3.dart';

class PackageRepositoryImpl implements PackageRepository {
  Database db;

  PackageRepositoryImpl(this.db);

  @override
  Future<PackageEntity> create(
      {required String name, required int ownerId}) async {
    try {
      db.execute("""
        INSERT INTO packages (name, owner_id) VALUES (?, ?)
      """, [name, ownerId]);
      return PackageEntity(
          id: db.lastInsertRowId, name: name, ownerId: ownerId);
    } catch (e) {
      throw StorageException(
          "Cant not create package entity: name - $name, ownerId - $ownerId (${e.toString()})");
    }
  }

  @override
  Future<void> delete() {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future<PackageEntity> getById(int id) {
    // TODO: implement getById
    throw UnimplementedError();
  }
}
