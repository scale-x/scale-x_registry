import 'package:scale_x_registry/storage/entities/file_entity.dart';

abstract class FileRepository {
  Future<FileEntity> create(
      {required String hash,
      required String path,
      required int artifactTypeId});
  Future<void> delete(int id);
  Future<FileEntity> findById(int id);
}
