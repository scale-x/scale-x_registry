import 'package:scale_x_registry/services/package_service.dart';
import 'package:scale_x_registry/storage/interfaces/owner_repository.dart';
import 'package:scale_x_registry/storage/interfaces/storage_factory.dart';
import 'package:scale_x_registry/services/interfaces/package_service.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

import '../storage_factory_builder.dart';

void main() async {
  group("PackageService", () {
    late StorageFactory storageFactory;
    late PackageService packageService;
    late OwnerRepository ownerRepository;

    setUpAll(() async {
      storageFactory = getStorageFactory();
      await storageFactory.start();
      ownerRepository = storageFactory.getOwnerRepository();
      final packageRepository = storageFactory.getPackageRepository();
      packageService = PackageServiceImpl(ownerRepository, packageRepository);
    });

    tearDownAll(() async {
      await storageFactory.stop();
    });

    group("create", () {
      test("create package successful if owner exists", () async {
        final owner = await ownerRepository.create(email: "aaa@mail.com");
        final package = await packageService.create(
            email: "aaa@mail.com", scope: "global", name: "aaa-package");
        expect(package.id > 0, true);
        expect(package.name, "aaa-package");
        expect(package.scope, "global");
        expect(package.ownerId, owner.id);
      });

      test("create new owner if not exists", () async {
        final package = await packageService.create(
            email: "bbb@mail.com", scope: "global", name: "bbb-package");
        expect(package.id > 0, true);
        expect(package.ownerId > 0, true);
        expect(package.name, "bbb-package");
        expect(package.scope, "global");
      });

      test("throws an error if package already exists", () async {
        await packageService.create(
            email: "ccc@mail.com", scope: "global", name: "ccc-package");
        expect(
            () async => await packageService.create(
                email: "ccc@mail.com", scope: "global", name: "ccc-package"),
            throwsA(isA()));
      });
    });

    group("get", () {
      test("returns package entity if exists", () async {
        final created = await packageService.create(
            email: "ddd@mail.com", scope: "global", name: "ddd-package");
        final selected =
            await packageService.get(scope: "global", name: "ddd-package");
        expect(created.id, selected.id);
        expect(created.name, selected.name);
        expect(created.ownerId, selected.ownerId);
        expect(created.scope, selected.scope);
      });

      test("throws an error if package not exists", () {
        expect(
            () async =>
                await packageService.get(scope: "global", name: "eee-package"),
            throwsA(isA()));
      });
    });
  }, tags: ['integration', 'service']);
}
