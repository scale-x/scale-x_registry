import 'package:scale_x_registry/config/entities/config_entity.dart';
import 'package:scale_x_registry/config/entities/sqlite_config_entity.dart';
import 'package:scale_x_registry/storage/interfaces/package_repository.dart';
import 'package:scale_x_registry/storage/interfaces/owner_repository.dart';
import 'package:scale_x_registry/storage/interfaces/storage_factory.dart';

class SqliteFactory implements StorageFactory {
  SqliteFactory(SqliteConfigEntity config) {

  }

  @override
  OwnerRepository getOwnerRepository() {
    // TODO: implement getOwnerRepository
    throw UnimplementedError();
  }

  @override
  PackageRepository getPackageRepository() {
    // TODO: implement getPackageRepository
    throw UnimplementedError();
  }
}
