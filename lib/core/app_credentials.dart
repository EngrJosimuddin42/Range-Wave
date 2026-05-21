import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppCredentials {
  static String get domain => dotenv.env['BASE_URL'] ?? 'https://rcw2z4rg-8000.inc1.devtunnels.ms/api';
  static const String wsDomain = 'ws://10.10.12.10:3000';
}