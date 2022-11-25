import 'dart:io';

class PostgresConfigEntity {
  String name;
  String user;
  String password;
  String host;
  int port;

  PostgresConfigEntity(
      {required this.name,
      required this.user,
      required this.password,
      required this.host,
      required this.port});

  PostgresConfigEntity? init(dynamic fileConfig) {
    var name =
        fileConfig['postgres']['name'] ?? Platform.environment['POSTGRES_NAME'];
    var user =
        fileConfig['postgres']['user'] ?? Platform.environment['POSTGRES_USER'];
    var host =
        fileConfig['postgres']['host'] ?? Platform.environment['POSTGRES_HOST'];
  }
}
