import 'package:scale_x_registry/exceptions/storage_exception.dart';
import 'package:scale_x_registry/storage/entities/package_entity.dart';
import 'package:scale_x_registry/storage/interfaces/mode_repository.dart';
import 'package:scale_x_registry/storage/interfaces/storage_factory.dart';
import 'package:test/test.dart';

import 'storage_factory_builder.dart';

void main() async {
  group("ModeRepository", () {
    late StorageFactory storageFactory;
    late PackageEntity packageEntity;
    late ModeRepository modeRepository;
    setUpAll(() async {
      storageFactory = getStorageFactory();
      await storageFactory.start();
      final ownerRepository = storageFactory.getOwnerRepository();
      final ownerEntity = await ownerRepository.create(email: "test@mail.com");
      final packageRepository = storageFactory.getPackageRepository();
      packageEntity =
          await packageRepository.create(name: 'test', ownerId: ownerEntity.id);
      modeRepository = storageFactory.getModeRepository();
    });

    tearDownAll(() async {
      await storageFactory.stop();
    });

    group("create", () {
      test("new entity", () async {
        final modeEntity = await modeRepository.create(
            packageId: packageEntity.id, title: "test_package");
        expect(modeEntity.title, "test_package");
        expect(modeEntity.id > 0, true);
      });

      test("throws an error on duplicate package and title", () async {
        await modeRepository.create(
            packageId: packageEntity.id, title: "test1");
        expect(
            () async => await modeRepository.create(
                packageId: packageEntity.id, title: "test1"),
            throwsA(isA<StorageException>()));
      });
    });

    group("getById", () {
      test("returns right entity", () async {
        final createdMode = await modeRepository.create(
            packageId: packageEntity.id, title: "test2");
        final selectedMode = await modeRepository.getById(createdMode.id);
        expect(createdMode.id, selectedMode.id);
        expect(createdMode.title, selectedMode.title);
        expect(createdMode.packageId, selectedMode.packageId);
      });

      test("throws an exception if entity not exists", () async {
        expect(() async => await modeRepository.getById(100),
            throwsA(isA<StorageException>()));
      });
    });

    group("delete", () {
      test("remove entity successful", () async {
        final modeEntity = await modeRepository.create(
            packageId: packageEntity.id, title: "test4");
        await modeRepository.delete(modeEntity.id);
        expect(() async => await modeRepository.getById(modeEntity.id),
            throwsA(isA<StorageException>()));
      });

      test("throws an exception if no entity exists", () async {
        expect(() async => await modeRepository.delete(1000),
            throwsA(isA<StorageException>()));
      });
    });
  }, tags: ['integration', 'storage']);
}
