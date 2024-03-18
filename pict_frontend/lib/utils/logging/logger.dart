import 'package:logger/logger.dart';

class LoggerHelper {
  static void debug(String message) {
    var logger = Logger();
    logger.d(message);
  }

  static void info(String message) {
    var logger = Logger();
    logger.i(message);
  }

  static void warn(String message) {
    var logger = Logger();
    logger.w(message);
  }

  static void error(String message) {
    var logger = Logger();
    logger.e(message);
  }
}
