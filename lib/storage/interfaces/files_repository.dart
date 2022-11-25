import 'package:scale_x_registry/storage/entities/file_entity.dart';

abstract class FilesRepository {
  Future<FileEntity> create({required String hash, required String path});
  Future<void> delete(int id);
  Future<void> findById(int id);
}
