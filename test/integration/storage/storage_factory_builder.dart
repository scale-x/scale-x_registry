import 'package:scale_x_registry/storage/interfaces/storage_factory.dart';
import 'package:scale_x_registry/storage/loc/storage_loc.dart';

import '../config_builder.dart';

StorageFactory getStorageFactory() {
  final config = getConfig();
  return StorageLocImp(config).getFactory();
}
