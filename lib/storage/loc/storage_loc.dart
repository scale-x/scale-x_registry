import 'package:scale_x_registry/config/entities/config_entity.dart';
import 'package:scale_x_registry/exceptions/storage_exception.dart';
import 'package:scale_x_registry/storage/interfaces/storage_factory.dart';
import 'package:scale_x_registry/storage/interfaces/storage_loc.dart';
import 'package:scale_x_registry/storage/sqlite/sqlite_factory.dart';

class StorageLocImp implements StorageLoc {
  final ConfigEntity _config;

  StorageLocImp(this._config);

  @override
  StorageFactory getFactory() {
    final sqlite = _config.sqlite;
    if (sqlite != null) {
      return SqliteFactory(sqlite);
    }
    throw StorageException("Can not get");
  }
}
