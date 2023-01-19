import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:scale_x_registry/api/utils/rest_response.dart';
import 'package:scale_x_registry/services/interfaces/package_service.dart';

class PackageController {
  final PackageService _packageService;

  PackageController(this._packageService);

  Future<Response> _create(Request request) async {
    final requestBody = await request.readAsString();
    final requestData = json.decode(requestBody);

    final String? scope = requestData['scope'];
    if (scope == null) {
      return RestResponse.badRequest("invalid scope: $scope");
    }
    final String? name = requestData['name'];
    if (name == null) {
      return RestResponse.badRequest("invalid name: $name");
    }
    final String? owner = requestData['owner'];
    if (owner == null) {
      return RestResponse.badRequest("invalid owner: $owner");
    }

    try {
      final package =
          await _packageService.create(email: owner, scope: scope, name: name);
      return RestResponse.ok(package.toJson());
    } catch (error) {
      return RestResponse.badRequest(error);
    }
  }

  Future<Response> _get(Request request) async {
    final scope = request.params['scope'];
    if (scope == null) {
      return RestResponse.badRequest("invalid scope: $scope");
    }
    final name = request.params['name'];
    if (name == null) {
      return RestResponse.badRequest("invalid package name: $name");
    }

    try {
      final packageEntity = await _packageService.get(scope: scope, name: name);
      return RestResponse.ok(packageEntity.toJson());
    } catch (error) {
      return RestResponse.notFound("package not found");
    }
  }

  Handler get router {
    final router = Router();
    router.post('/package', _create);
    router.get('/package/<scope>/<name>', _get);
    return router;
  }
}
