import 'package:scale_x_registry/exceptions/storage_exception.dart';
import 'package:scale_x_registry/storage/entities/owner_entity.dart';
import 'package:scale_x_registry/storage/interfaces/owner_repository.dart';
import 'package:sqlite3/sqlite3.dart';

class OwnerRepositoryImpl implements OwnerRepository {
  final Database _db;

  OwnerRepositoryImpl(this._db);

  @override
  Future<OwnerEntity> create({required String email}) async {
    try {
      _db.execute("""
        INSERT INTO owners (email) VALUES (?)
      """, [email]);
      return OwnerEntity(id: _db.lastInsertRowId, email: email);
    } catch (e) {
      throw StorageException(
          "Cant not create owner entity: email - $email (${e.toString()})");
    }
  }

  @override
  Future<void> delete(int id) async {
    try {
      _db.execute("""
        DELETE FROM owners WHERE id = ? LIMIT 1
      """, [id]);
      final result = _db.select("""
        SELECT changes() as deleted;
      """);
      if (result.first["deleted"] != 1) {
        throw StorageException("entity was not deleted");
      }
    } catch (e) {
      throw StorageException(
          "Cant not delete owner entity: id - $id (${e.toString()})");
    }
  }

  @override
  Future<OwnerEntity> getById(int id) async {
    try {
      final result = _db.select("""
        SELECT id, email FROM owners WHERE id = ?
      """, [id]);
      return OwnerEntity(id: result.first['id'], email: result.first['email']);
    } catch (e) {
      throw StorageException(
          "Cant not select owner entity: id - $id (${e.toString()})");
    }
  }
}
