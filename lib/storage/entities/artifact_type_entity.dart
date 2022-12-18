import 'package:scale_x_registry/exceptions/storage_exception.dart';

class ArtifactTypeEntity {
  int id;
  String title;

  ArtifactTypeEntity({required this.id, required this.title});

  factory ArtifactTypeEntity.local() {
    return ArtifactTypeEntity(id: 1, title: "local");
  }

  factory ArtifactTypeEntity.s3() {
    return ArtifactTypeEntity(id: 2, title: "s3");
  }

  factory ArtifactTypeEntity.fromId(int id) {
    switch (id) {
      case 1:
        return ArtifactTypeEntity.local();
      case 2:
        return ArtifactTypeEntity.s3();
      default:
        throw StorageException("Invalid artifacts id - $id");
    }
  }
}
