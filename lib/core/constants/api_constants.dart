import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConstants {
  static final baseUrl = dotenv.env['API_URL'] ?? "http://192.168.18.11:8000";
}