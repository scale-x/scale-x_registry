class Migration {
  int key;
  String value;

  Migration(this.key, this.value);
}

const _migration001 = """
  CREATE TABLE migrations (
    migration INTEGER NOT NULL
  );
""";

const _migration002 = """
  CREATE TABLE files (
    id INT PRIMARY KEY,
    hash TEXT NOT NULL,
    group TEXT NOT NULL,
    path TEXT NOT NULL
  );
""";

const _migration003 = """
  CREATE TABLE packages (
    id INT PRIMARY KEY,
    name TEXT NOT NULL,
    mail TEXT NOT NULL
  );
""";

final List<Migration> migrations = [
  Migration(1, _migration001),
  Migration(2, _migration002),
  Migration(3, _migration003)
];
