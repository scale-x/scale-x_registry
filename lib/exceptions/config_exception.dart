class ConfigException implements Exception {
  final String _message;

  ConfigException(this._message);

  @override
  String toString() {
    return _message;
  }
}
