import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppCredentials {
  static String get domain => dotenv.env['BASE_URL'] ?? 'https://87dzb7n8-8000.asse.devtunnels.ms/api';
  static const String wsDomain = 'ws://10.10.12.10:3000';



  static String resolveUrl(String path) {
    if (path.isEmpty) return '';
    if (path.contains('localhost') || path.contains('127.0.0.1')) {
      final uri = Uri.parse(path);
      final base = domain
          .replaceAll(RegExp(r'/api$'), '')
          .replaceAll(RegExp(r'/$'), '');
      return path.replaceFirst(
        '${uri.scheme}://${uri.host}:${uri.port}',
        base,
      );
    }
    if (path.startsWith('http')) return path;
    final base = domain
        .replaceAll(RegExp(r'/api$'), '')
        .replaceAll(RegExp(r'/$'), '');
    return path.startsWith('/') ? '$base$path' : '$base/$path';
  }
}