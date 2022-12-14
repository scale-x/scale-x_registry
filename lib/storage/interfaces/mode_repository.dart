import 'package:scale_x_registry/storage/entities/mode_entity.dart';

abstract class ModeRepository {
  Future<ModeEntity> create({required int packageId, required String title});
  Future<void> delete(int id);
  Future<ModeEntity> getById(int id);
}
