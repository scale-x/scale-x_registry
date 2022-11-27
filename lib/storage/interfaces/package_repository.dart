import 'package:scale_x_registry/storage/entities/package_entity.dart';

abstract class PackageRepository {
  Future<PackageEntity> create({required String name, required int ownerId});
  Future<PackageEntity> getById(int id);
  Future<void> delete();
}
