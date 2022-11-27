import 'package:scale_x_registry/storage/entities/owner_entity.dart';

abstract class OwnerRepository {
  Future<OwnerEntity> create({required String email});
  Future<void> delete(int id);
  Future<OwnerEntity> getById(int id);
}
