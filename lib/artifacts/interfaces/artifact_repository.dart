abstract class ArtifactRepository {
  Future<String> save(String path);
  Future<void> delete(String path);
  Stream<List<int>> get(String path);
}
