import 'package:scale_x_registry/storage/entities/package_entity.dart';

abstract class PackageService {
  Future<PackageEntity> create({
    required String email,
    required String scope,
    required String name,
  });

  Future<PackageEntity> get({
    required String scope,
    required String name,
  });
}
