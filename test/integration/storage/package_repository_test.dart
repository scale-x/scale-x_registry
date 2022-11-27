import 'package:scale_x_registry/exceptions/storage_exception.dart';
import 'package:scale_x_registry/storage/entities/owner_entity.dart';
import 'package:scale_x_registry/storage/interfaces/package_repository.dart';
import 'package:scale_x_registry/storage/sqlite/migration_repository.dart';
import 'package:scale_x_registry/storage/sqlite/owner_repository.dart';
import 'package:scale_x_registry/storage/sqlite/package_repository.dart';
import 'package:scale_x_registry/storage/sqlite/sqlite_service.dart';
import 'package:sqlite3/sqlite3.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

void main() async {
  group("PackageRepository", () {
    late Database db;
    late OwnerEntity owner;
    late PackageRepository repository;
    setUp(() async {
      db = sqlite3.openInMemory();
      final migrationRepository = MigrationRepository(db);
      final sqliteService = SqliteService(migrationRepository);
      await sqliteService.start();
      final ownerRepository = OwnerRepositoryImpl(db);
      owner = await ownerRepository.create(email: "test@mail.com");
      repository = PackageRepositoryImpl(db);
    });

    tearDown(() {
      db.dispose();
    });

    group('create', () {
      test("creates an entity successful with empty namespace", () async {
        final package =
            await repository.create(name: "test", ownerId: owner.id);
        expect(package.id > 0, true);
        expect(package.namespace, "common");
        expect(package.name, "test");
        expect(package.ownerId, owner.id);
      });

      test("creates an entity with namespace", () async {
        final package = await repository.create(
            name: "test2", ownerId: owner.id, namespace: "custom");
        expect(package.id > 0, true);
        expect(package.namespace, "custom");
        expect(package.name, "test2");
        expect(package.ownerId, owner.id);
      });

      test('throws an exception on duplicate name', () async {
        await repository.create(name: "test1", ownerId: owner.id);
        expect(
            () async =>
                await repository.create(name: "test1", ownerId: owner.id),
            throwsA(isA<StorageException>()));
      });

      test('throws an exception on duplicate name with namespace', () async {
        await repository.create(
            name: "test3", namespace: "custom", ownerId: owner.id);
        expect(
            () async => await repository.create(
                name: "test3", namespace: "custom", ownerId: owner.id),
            throwsA(isA<StorageException>()));
      });
    });

    group("delete", () {
      test("remove entity successful", () async {
        final package =
            await repository.create(name: "delete1", ownerId: owner.id);
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
      test("remove entity successful", () async {
        final package =
            await repository.create(name: "getById", ownerId: owner.id);
        await repository.delete(package.id);
        expect(() async => await repository.getById(owner.id),
            throwsA(isA<StorageException>()));
      });

      test("throws an exception if no entity exists", () async {
        expect(() async => await repository.delete(1000),
            throwsA(isA<StorageException>()));
      });
    });
  }, tags: ['integration']);
}
