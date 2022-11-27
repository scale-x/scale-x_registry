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
  CREATE TABLE owners (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    email TEST NOT NULL UNIQUE
  );
""";

const _migration003 = """
  CREATE TABLE packages (
    id INTEGER PRIMARY KEY,
    name TEXT NOT NULL UNIQUE,
    owner_id INTEGER NOT NULL,
    FOREIGN KEY(owner_id) REFERENCES owners(id)
  ); 
""";

// const _migration003 = """
//   CREATE TABLE files (
//     id INT PRIMARY KEY,
//     hash TEXT NOT NULL,
//     group TEXT NOT NULL,
//     path TEXT NOT NULL
//   );
// """;

final List<Migration> migrations = [
  Migration(1, _migration001),
  Migration(2, _migration002),
  Migration(3, _migration003),
  // Migration(4, _migration004)
];
