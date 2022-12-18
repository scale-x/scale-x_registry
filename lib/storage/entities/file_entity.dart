class FileEntity {
  int id;
  String hash;
  String path;
  int artifactTypeId;

  FileEntity(
      {required this.id,
      required this.hash,
      required this.path,
      required this.artifactTypeId});
}
