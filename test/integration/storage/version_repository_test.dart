import 'package:scale_x_registry/exceptions/storage_exception.dart';
import 'package:scale_x_registry/storage/entities/package_entity.dart';
import 'package:scale_x_registry/storage/interfaces/storage_factory.dart';
import 'package:scale_x_registry/storage/interfaces/version_repository.dart';
import 'package:test/test.dart';

import 'storage_factory_builder.dart';

void main() async {
  group("VersionRepository", () {
    late StorageFactory storageFactory;
    late PackageEntity packageEntity;
    late VersionRepository versionRepository;

    setUpAll(() async {
      storageFactory = getStorageFactory();
      await storageFactory.start();
      final ownerRepository = storageFactory.getOwnerRepository();
      final ownerEntity = await ownerRepository.create(email: "test@mail.com");
      final packageRepository = storageFactory.getPackageRepository();
      packageEntity =
          await packageRepository.create(name: 'test', ownerId: ownerEntity.id);
      versionRepository = storageFactory.getVersionRepository();
    });

    tearDownAll(() async {
      await storageFactory.stop();
    });

    group("create", () {
      test("new entity", () async {
        final versionEntity = await versionRepository.create(
            packageId: packageEntity.id,
            major: 0,
            minor: 1,
            path: 32,
            postfix: 'alpha');
        expect(versionEntity.packageId, packageEntity.id);
        expect(versionEntity.major, 0);
        expect(versionEntity.minor, 1);
        expect(versionEntity.path, 32);
        expect(versionEntity.postfix, 'alpha');
        expect(versionEntity.id > 0, true);
      });

      test("new entity with empty postfix", () async {
        final versionEntity = await versionRepository.create(
            packageId: packageEntity.id, major: 0, minor: 1, path: 32);
        expect(versionEntity.packageId, packageEntity.id);
        expect(versionEntity.major, 0);
        expect(versionEntity.minor, 1);
        expect(versionEntity.path, 32);
        expect(versionEntity.postfix, null);
        expect(versionEntity.id > 0, true);
      });

      test("throws an error on duplicate package and title", () async {
        await versionRepository.create(
            packageId: packageEntity.id, major: 0, minor: 1, path: 32);
        expect(
            () async => await versionRepository.create(
                packageId: packageEntity.id, major: 0, minor: 1, path: 32),
            throwsA(isA<StorageException>()));
      });
    });

    group("getById", () {
      test("returns right entity", () async {
        final createdEntity = await versionRepository.create(
            packageId: packageEntity.id,
            major: 0,
            minor: 1,
            path: 32,
            postfix: 'alpha');
        final selectedEntity =
            await versionRepository.getById(createdEntity.id);
        expect(createdEntity.id, selectedEntity.id);
        expect(createdEntity.packageId, selectedEntity.packageId);
        expect(createdEntity.major, selectedEntity.major);
        expect(createdEntity.minor, selectedEntity.minor);
        expect(createdEntity.path, selectedEntity.path);
        expect(createdEntity.postfix, selectedEntity.postfix);
      });

      test("throws an exception if entity not exists", () async {
        expect(() async => await versionRepository.getById(100),
            throwsA(isA<StorageException>()));
      });
    });

    group("delete", () {
      test("remove entity successful", () async {
        final versionEntity = await versionRepository.create(
            packageId: packageEntity.id, major: 1, minor: 1, path: 32);
        await versionRepository.delete(versionEntity.id);
        expect(() async => await versionRepository.getById(versionEntity.id),
            throwsA(isA<StorageException>()));
      });

      test("throws an exception if no entity exists", () async {
        expect(() async => await versionRepository.delete(1000),
            throwsA(isA<StorageException>()));
      });
    });
  }, tags: ['integration', 'storage']);
}
