import 'package:flutter_dotenv/flutter_dotenv.dart';

String baseUrl = dotenv.get('BASE_URL');
String environment = dotenv.get('APP_ENV');
