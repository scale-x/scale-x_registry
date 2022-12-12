import 'package:scale_x_registry/storage/interfaces/owner_repository.dart';
import 'package:scale_x_registry/storage/interfaces/package_repository.dart';

abstract class StorageFactory {
  OwnerRepository getOwnerRepository();
  PackageRepository getPackageRepository();  
}
