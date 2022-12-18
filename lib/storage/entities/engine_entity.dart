import 'package:scale_x_registry/exceptions/storage_exception.dart';

class EngineEntity {
  int id;
  String title;

  EngineEntity({required this.id, required this.title});

  factory EngineEntity.compose() {
    return EngineEntity(id: 1, title: 'compose');
  }

  factory EngineEntity.kubernetes() {
    return EngineEntity(id: 2, title: 'kubernetes');
  }

  factory EngineEntity.fromId(int id) {
    switch (id) {
      case 1:
        return EngineEntity.compose();
      case 2:
        return EngineEntity.kubernetes();
      default:
        throw StorageException("Invalid engine id: $id");
    }
  }
}
