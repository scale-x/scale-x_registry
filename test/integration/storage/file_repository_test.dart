import 'package:scale_x_registry/exceptions/storage_exception.dart';
import 'package:scale_x_registry/storage/entities/artifact_type_entity.dart';
import 'package:scale_x_registry/storage/interfaces/file_repository.dart';
import 'package:scale_x_registry/storage/interfaces/storage_factory.dart';
import 'package:test/test.dart';

import 'storage_factory_builder.dart';

void main() async {
  group("FileRepository", () {
    late StorageFactory storageFactory;
    late FileRepository fileRepository;

    setUpAll(() async {
      storageFactory = getStorageFactory();
      await storageFactory.start();
      fileRepository = storageFactory.getFileRepository();
    });

    tearDownAll(() async {
      await storageFactory.stop();
    });

    group("create", () {
      test("new entity", () async {
        final artifact = ArtifactTypeEntity.local();
        final fileEntity = await fileRepository.create(
            hash: "hash", path: "test/path", artifactTypeId: artifact.id);
        expect(fileEntity.id > 0, true);
        expect(fileEntity.hash, "hash");
        expect(fileEntity.artifactTypeId, artifact.id);
        expect(fileEntity.path, "test/path");
      });

      test("throws an error on duplicate hash and artifact type", () async {
        final artifact = ArtifactTypeEntity.local();
        await fileRepository.create(
            hash: "hash1", path: "test/path", artifactTypeId: artifact.id);
        expect(
            () async => await fileRepository.create(
                hash: "hash1", path: "test/path2", artifactTypeId: artifact.id),
            throwsA(isA<StorageException>()));
      });
    });

    group("getById", () {
      test("returns right entity", () async {
        final artifactType = ArtifactTypeEntity.local();
        final createdEntity = await fileRepository.create(
            hash: "hash4", path: "path/test", artifactTypeId: artifactType.id);
        final selectedEntity = await fileRepository.findById(createdEntity.id);
        expect(createdEntity.id, selectedEntity.id);
        expect(createdEntity.hash, selectedEntity.hash);
        expect(createdEntity.path, selectedEntity.path);
        expect(createdEntity.artifactTypeId, selectedEntity.artifactTypeId);
      });

      test("throws an exception if entity not exists", () async {
        expect(() async => await fileRepository.findById(100),
            throwsA(isA<StorageException>()));
      });
    });

    group("delete", () {
      test("remove entity successful", () async {
        final artifact = ArtifactTypeEntity.local();
        final fileEntity = await fileRepository.create(
            hash: "hash6", path: "test/path", artifactTypeId: artifact.id);
        await fileRepository.delete(fileEntity.id);
        expect(() async => await fileRepository.findById(fileEntity.id),
            throwsA(isA<StorageException>()));
      });

      test("throws an exception if no entity exists", () async {
        expect(() async => await fileRepository.delete(1000),
            throwsA(isA<StorageException>()));
      });
    });
  }, tags: ['integration', 'storage']);
}
