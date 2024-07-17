import 'package:logger/logger.dart';

class Logs {
  static final Logger logger = Logger(
    printer: PrettyPrinter(),
    level: Level.debug,
  );

  static void log(String message) => logger.d(message);

  static void elog(String message) => logger.e(message);
}
