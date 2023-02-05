import 'dart:io';

import 'package:args/args.dart';
import 'package:path/path.dart';
import 'package:scale_x_registry/api/client/controllers/package_controller.dart';
import 'package:scale_x_registry/config/config_factory.dart';
import 'package:scale_x_registry/services/services_factory.dart';
import 'package:scale_x_registry/storage/storage_loc.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
// import 'package:shelf_hotreload/shelf_hotreload.dart';
import 'package:shelf_router/shelf_router.dart';

// void main(List<String> args) async {
//   return withHotreload(() => createServer(args));
// }

void main(List<String> args) async {
  // params
  final argParser = ArgParser();
  argParser.addOption('port', abbr: 'p', help: 'Port to use. Default: 8080');
  argParser.addOption('address',
      abbr: 'a', help: 'Address to use. Default internal ip address');
  argParser.addOption('config', abbr: 'c', help: 'Path to config file.');

  final params = argParser.parse(args);

  final configPath =
      params['config'] ?? join(dirname(Platform.script.path), 'config.yml');

  // config
  final config = await ConfigFactoryImpl(configPath).getConfig();

  // storage
  final storage = StorageLocImp(config).getFactory();
  await storage.start();

  // services
  final services = ServicesFactoryImpl(storage);

  // controllers
  final packageController = PackageController(services.getPackageService());

  // mount controllers
  final router = Router()..mount('/api/internal', packageController.router);
  final handler = Pipeline().addMiddleware(logRequests()).addHandler(router);

  // Use any available host or container IP (usually `0.0.0.0`).
  final ip = InternetAddress.anyIPv4;
  final port =
      params['port'] != null ? int.tryParse(params['port']) ?? 8080 : 8080;
  print("@@@ port => $port");
  serve(handler, ip, port);
}
