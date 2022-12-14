import 'package:scale_x_registry/storage/interfaces/owner_repository.dart';
import 'package:scale_x_registry/storage/interfaces/package_repository.dart';

abstract class StorageFactory {
  Future<void> start();

  Future<void> stop();

  OwnerRepository getOwnerRepository();

  PackageRepository getPackageRepository();
}
