class VersionEntity {
  int id;
  int packageId;
  int major;
  int minor;
  int path;
  String? postfix;

  VersionEntity(
      {required this.id,
      required this.packageId,
      required this.minor,
      required this.major,
      required this.path,
      this.postfix});
}
