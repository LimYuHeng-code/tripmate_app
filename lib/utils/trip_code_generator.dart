import 'dart:math';

class TripCodeGenerator {
  static const String _chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';

  static String generate({int length = 4}) {
    final random = Random.secure();
    return List.generate(
      length,
      (_) => _chars[random.nextInt(_chars.length)],
    ).join();
  }
}
