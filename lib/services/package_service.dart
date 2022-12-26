import 'package:scale_x_registry/services/interfaces/package_service.dart';
import 'package:scale_x_registry/storage/entities/package_entity.dart';
import 'package:scale_x_registry/storage/interfaces/owner_repository.dart';
import 'package:scale_x_registry/storage/interfaces/package_repository.dart';

class PackageServiceImpl implements PackageService {
  final PackageRepository _packageRepository;
  final OwnerRepository _ownerRepository;

  PackageServiceImpl(this._ownerRepository, this._packageRepository);

  @override
  Future<PackageEntity> create(
      {required String email,
      required String scope,
      required String name}) async {
    final owner = await _ownerRepository.getByEmail(email);
    return await _packageRepository.create(
        scope: scope, name: name, ownerId: owner.id);
  }

  @override
  Future<PackageEntity> get(
      {required String scope, required String name}) async {
    return await _packageRepository.getByScopeAndName(scope: scope, name: name);
  }
}
