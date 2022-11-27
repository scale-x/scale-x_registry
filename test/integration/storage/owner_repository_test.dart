import 'package:scale_x_registry/exceptions/storage_exception.dart';
import 'package:scale_x_registry/storage/sqlite/migration_repository.dart';
import 'package:scale_x_registry/storage/sqlite/owner_repository.dart';
import 'package:scale_x_registry/storage/sqlite/sqlite_service.dart';
import 'package:sqlite3/sqlite3.dart';
import 'package:test/test.dart';

void main() async {
  group("OwnerRepositoryImp", () {
    late Database db;
    late OwnerRepositoryImpl repository;
    setUpAll(() async {
      db = sqlite3.openInMemory();
      final migrationRepository = MigrationRepository(db);
      final sqliteService = SqliteService(migrationRepository);
      await sqliteService.start();
      repository = OwnerRepositoryImpl(db);
    });

    tearDownAll(() async {
      db.dispose();
    });

    group("create", () {
      test("new entity", () async {
        final owner = await repository.create(email: "test@mail.com");
        expect(owner.email, "test@mail.com");
        expect(owner.id > 0, true);
      });

      test("throws an error on duplicate error", () async {
        await repository.create(email: "test1@mail.com");
        expect(() async => await repository.create(email: "test1@mail.com"),
            throwsA(isA<StorageException>()));
      });
    });

    group("getById", () {
      test("returns right entity", () async {
        final createdOwner = await repository.create(email: "eee@mail.com");
        final selectedOwner = await repository.getById(createdOwner.id);
        expect(createdOwner.id, selectedOwner.id);
        expect(createdOwner.email, selectedOwner.email);
      });

      test("throws an exception if entity not exists", () async {
        expect(() async => await repository.getById(100),
            throwsA(isA<StorageException>()));
      });
    });

    group("delete", () {
      test("remove entity successful", () async {
        final owner = await repository.create(email: "delete@mail.com");
        await repository.delete(owner.id);
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
