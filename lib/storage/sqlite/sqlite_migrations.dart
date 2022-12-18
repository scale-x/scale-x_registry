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
    namespace TEXT NOT NULL,
    name TEXT NOT NULL,
    owner_id INTEGER NOT NULL,
    UNIQUE(namespace, name),
    FOREIGN KEY(owner_id) REFERENCES owners(id)
  ); 
""";

const _migration004 = """
  CREATE TABLE modes (
    id INTEGER PRIMARY KEY,
    package_id INTEGER NOT NULL,
    title TEXT NOT NULL,
    UNIQUE(package_id, title),
    FOREIGN KEY(package_id) REFERENCES packages(id)
  );
""";

const _migration005 = """
  CREATE TABLE versions (
    id INTEGER PRIMARY KEY,
    package_id INTEGER NOT NULL,
    major INTEGER NOT NULL,
    minor INTEGER NOT NULL,
    path INTEGER NOT NULL,
    postfix TEXT,
    UNIQUE (package_id, major, minor, path, postfix),
    FOREIGN KEY(package_id) REFERENCES packages(id)
  );
""";

const _migration006 = """
  CREATE TABLE files (
    id INTEGER PRIMARY KEY,
    artifact_type_id INTEGER NOT NULL,
    hash TEXT NOT NULL,
    path TEXT NOT NULL,
    UNIQUE (hash, artifact_type_id)
  );
""";

// const _migration007 = """
//   CREATE TABLE packages_modes_engines_versions_files (
//     package_id INTEGER NOT NULL,
//     mode_id INTEGER NOT NULL,
//     engine_id INTEGER NOT NULL,
//     version_id INTEGER NOT NULL,
//     file_id INTEGER NOT NULL,
//   );
// """;

final List<Migration> migrations = [
  Migration(1, _migration001),
  Migration(2, _migration002),
  Migration(3, _migration003),
  Migration(4, _migration004),
  Migration(5, _migration005),
  Migration(6, _migration006),
  // Migration(7, _migration007),
];
