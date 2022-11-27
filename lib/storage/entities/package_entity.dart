class PackageEntity {
  int id;
  int ownerId;
  String namespace;
  String name;

  PackageEntity(
      {required this.id,
      required this.namespace,
      required this.name,
      required this.ownerId});
}
