class PackageEntity {
  int id;
  int ownerId;
  String scope;
  String name;

  PackageEntity(
      {required this.id,
      required this.scope,
      required this.name,
      required this.ownerId});

  Map<String, dynamic> toJson() {
    return {'id': id, 'ownerId': ownerId, 'scope': scope, 'name': name};
  }
}
