class FileEntity {
  int id;
  String hash;
  String group;
  String path;

  FileEntity(
      {required this.id,
      required this.hash,
      required this.path,
      required this.group});
}
