import "package:path/path.dart" show dirname, join;
import 'dart:io' show Platform;

main() {
  print(join(dirname(Platform.script.path), 'test_data_file.dat'));
}
