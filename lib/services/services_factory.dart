import 'package:scale_x_registry/services/interfaces/package_service.dart';
import 'package:scale_x_registry/services/interfaces/services_factory.dart';
import 'package:scale_x_registry/storage/interfaces/storage_factory.dart';
import 'package:scale_x_registry/services/package_service.dart';

class ServicesFactoryImpl implements ServicesFactory {
  final StorageFactory _storageFactory;

  ServicesFactoryImpl(this._storageFactory);

  @override
  PackageService getPackageService() {
    final ownerRepository = _storageFactory.getOwnerRepository();
    final packageRepository = _storageFactory.getPackageRepository();

    return PackageServiceImpl(ownerRepository, packageRepository);
  }
}
