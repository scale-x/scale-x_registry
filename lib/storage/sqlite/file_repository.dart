import 'package:scale_x_registry/exceptions/storage_exception.dart';
import 'package:scale_x_registry/storage/entities/file_entity.dart';
import 'package:scale_x_registry/storage/interfaces/file_repository.dart';
import 'package:sqlite3/sqlite3.dart';

class FileRepositoryImp implements FileRepository {
  final Database _db;

  FileRepositoryImp(this._db);

  @override
  Future<FileEntity> create(
      {required String hash,
      required String path,
      required int artifactTypeId}) async {
    try {
      _db.execute("""
        INSERT INTO files (hash, path, artifact_type_id) VALUES (?, ?, ?)
      """, [hash, path, artifactTypeId]);
      return FileEntity(
          id: _db.lastInsertRowId,
          hash: hash,
          path: path,
          artifactTypeId: artifactTypeId);
    } catch (e) {
      throw StorageException(
          "Cant not create file entity: hash - $hash, path $path, artifactTypeId $artifactTypeId (${e.toString()})");
    }
  }

  @override
  Future<void> delete(int id) async {
    try {
      _db.execute("""
        DELETE FROM files WHERE id = ? LIMIT 1
      """, [id]);
      final result = _db.select("""
        SELECT changes() as deleted;
      """);
      if (result.first["deleted"] != 1) {
        throw StorageException("entity was not deleted");
      }
    } catch (e) {
      throw StorageException(
          "Cant not delete file entity: id - $id (${e.toString()})");
    }
  }

  @override
  Future<FileEntity> findById(int id) async {
    try {
      final result = _db.select("""
        SELECT id, hash, path, artifact_type_id FROM files WHERE id = ?
      """, [id]);
      return FileEntity(
          id: result.first['id'],
          hash: result.first['hash'],
          path: result.first['path'],
          artifactTypeId: result.first['artifact_type_id']);
    } catch (e) {
      throw StorageException(
          "Cant not select modes entity: id - $id (${e.toString()})");
    }
  }
}
