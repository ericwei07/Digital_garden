import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfig {
  AppConfig._();

  static String get baseUrl {
    return dotenv.env['BASE_URL'] ?? 'https://staging.dev.shukebeta.com';
  }

  // duplicate request error, which shouldn't bother to show anything
  static int get errorCodeQuiet => 105;
}