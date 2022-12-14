import 'package:scale_x_registry/storage/entities/version_entity.dart';

abstract class VersionRepository {
  Future<VersionEntity> create(
      {required int packageId,
      required int minor,
      required int major,
      required int path,
      String? postfix});
  Future<void> delete(int id);
  Future<VersionEntity> getById(int id);
}
