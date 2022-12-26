import 'package:scale_x_registry/storage/entities/package_entity.dart';

abstract class PackageRepository {
  Future<PackageEntity> create(
      {required String scope, required String name, required int ownerId});
  Future<PackageEntity> getById(int id);
  Future<PackageEntity> getByScopeAndName(
      {required String scope, required String name});
  Future<void> delete(int id);
}
