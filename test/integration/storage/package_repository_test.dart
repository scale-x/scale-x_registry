import 'package:scale_x_registry/exceptions/storage_exception.dart';
import 'package:scale_x_registry/storage/entities/owner_entity.dart';
import 'package:scale_x_registry/storage/interfaces/package_repository.dart';
import 'package:scale_x_registry/storage/interfaces/storage_factory.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

import 'storage_factory_builder.dart';

void main() async {
  group("PackageRepository", () {
    late StorageFactory storageFactory;
    late OwnerEntity owner;
    late PackageRepository repository;
    setUp(() async {
      storageFactory = getStorageFactory();
      await storageFactory.start();
      repository = storageFactory.getPackageRepository();
      final ownerRepository = storageFactory.getOwnerRepository();
      owner = await ownerRepository.create(email: "test@mail.com");
    });

    tearDown(() async {
      await storageFactory.stop();
    });

    group('create', () {
      test("creates an entity successful with empty namespace", () async {
        final package = await repository.create(
            scope: 'global', name: "test", ownerId: owner.id);
        expect(package.id > 0, true);
        expect(package.scope, "global");
        expect(package.name, "test");
        expect(package.ownerId, owner.id);
      });

      test("creates an entity with namespace", () async {
        final package = await repository.create(
            name: "test2", ownerId: owner.id, scope: "custom");
        expect(package.id > 0, true);
        expect(package.scope, "custom");
        expect(package.name, "test2");
        expect(package.ownerId, owner.id);
      });

      test('throws an exception on duplicate name', () async {
        await repository.create(
            scope: 'global', name: "test1", ownerId: owner.id);
        expect(
            () async => await repository.create(
                scope: 'global', name: "test1", ownerId: owner.id),
            throwsA(isA<StorageException>()));
      });

      test('throws an exception on duplicate name with namespace', () async {
        await repository.create(
            name: "test3", scope: "custom", ownerId: owner.id);
        expect(
            () async => await repository.create(
                name: "test3", scope: "custom", ownerId: owner.id),
            throwsA(isA<StorageException>()));
      });
    });

    group("delete", () {
      test("remove entity successful", () async {
        final package = await repository.create(
            scope: 'global', name: "delete1", ownerId: owner.id);
        await repository.delete(package.id);
        expect(() async => await repository.getById(package.id),
            throwsA(isA<StorageException>()));
      });
      test("throws an exception if no entity exists", () async {
        expect(() async => await repository.delete(1000),
            throwsA(isA<StorageException>()));
      });
    });

    group("getById", () {
      test("returns right entity", () async {
        final created = await repository.create(
            scope: 'global', name: 'package-ooo', ownerId: owner.id);
        final selected = await repository.getById(created.id);
        expect(created.id, selected.id);
        expect(created.scope, selected.scope);
        expect(created.name, selected.name);
        expect(created.ownerId, selected.ownerId);
      });

      test("throws an exception if entity not exists", () async {
        expect(() async => await repository.getById(100),
            throwsA(isA<StorageException>()));
      });
    });

    group("getByScopeAndName", () {
      test("returns right entity", () async {
        final createdMode = await repository.create(
            scope: 'global', name: 'package-yyy', ownerId: owner.id);
        final selectedMode = await repository.getByScopeAndName(
            scope: 'global', name: 'package-yyy');
        expect(createdMode.id, selectedMode.id);
        expect(createdMode.scope, selectedMode.scope);
        expect(createdMode.name, selectedMode.name);
        expect(createdMode.ownerId, selectedMode.ownerId);
      });

      test("throws an exception if entity not exists", () async {
        expect(() async => await repository.getById(100),
            throwsA(isA<StorageException>()));
      });
    });
  }, tags: ['integration', 'storage']);
}
