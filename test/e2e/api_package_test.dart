import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:test/test.dart';

import 'test_utils.dart';

void main() {
  group('Package - Endpoint', () {
    late Process p;

    setUp(() async {
      p = await Process.start(
        'dart',
        ['run', 'bin/registry.dart'],
      );
      await p.stdout.first;
    });

    tearDown(() => p.kill());

    group('/package', () {
      test('GET non existing package', () async {
        final name = generateRandomString(10);
        final response = await http.get(Uri.parse(
            'http://localhost:8080/api/internal/package/global/test_non_exists'));
        expect(response.statusCode, HttpStatus.notFound);
      });
      test('POST create new package', () async {
        final name = generateRandomString(10);
        final response = await http.post(
            Uri.parse('http://localhost:8080/api/internal/package'),
            body: jsonEncode(
                {"scope": "global", "name": name, "owner": "test@mail.com"}));
        expect(response.statusCode, HttpStatus.ok);

        final body = jsonDecode(response.body);
        expect(body['status'], HttpStatus.ok);
        expect(body['data']['id'] > 0, true);
        expect(body['data']['scope'], 'global');
        expect(body['data']['name'], name);
      });

      test('GET single package', () async {
        final name = generateRandomString(10);
        await http.post(Uri.parse('http://localhost:8080/api/internal/package'),
            body: jsonEncode(
                {"scope": "global", "name": name, "owner": "test@mail.com"}));
        final response = await http.get(Uri.parse(
            'http://localhost:8080/api/internal/package/global/$name'));
        final body = jsonDecode(response.body);
        expect(response.statusCode, HttpStatus.ok);
        expect(body['data']['id'] > 0, true);
        expect(body['data']['scope'], 'global');
        expect(body['data']['name'], name);
      });
    });
  }, tags: ['e2e']);
}
