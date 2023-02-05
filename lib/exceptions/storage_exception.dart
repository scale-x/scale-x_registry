class StorageException implements Exception {
  final String _message;

  StorageException(this._message);

  @override
  String toString() {
    return _message;
  }
}
