import 'dart:convert';
import 'dart:io';
import 'package:shelf/shelf.dart';

class RestResponse {
  static Response ok(dynamic data) {
    final status = HttpStatus.ok;
    return Response(status,
        body: json.encode({'data': data, 'status': status}));
  }

  static Response okPaginated(dynamic data, int total) {
    final status = HttpStatus.ok;
    return Response(status,
        body: json.encode({'data': data, 'status': status, 'total': total}));
  }

  static Response badRequest(dynamic error) {
    final status = HttpStatus.badRequest;
    return Response(status,
        body: json.encode({'error': error, 'status': status}));
  }

  static Response notFound(dynamic error) {
    final status = HttpStatus.notFound;
    return Response(status,
        body: json.encode({'error': error, 'status': status}));
  }
}
