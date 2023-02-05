import 'dart:math';

String generateRandomString(int len) {
  var r = Random();
  const _chars = 'qwertyuiopasdfghjklzxcvbnm-';
  return List.generate(len, (index) => _chars[r.nextInt(_chars.length)]).join();
}
