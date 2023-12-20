import 'package:lakasir/config/app.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<bool> checkAuthentication() async {
  final token = await getToken(); // Retrieve the user's token
  if (token != null) {
    return true; // Authentication is valid
  } else {
    return false; // Authentication failed; redirect to login or show an error
  }
}

Future<void> logout() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('token');
}

Future<void> storeToken(String token) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('token', token);
}

Future<String?> getToken() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('token');
}

Future<String> getDomain() async {
  final prefs = await SharedPreferences.getInstance();
  if (prefs.getString('domain') == null) {
    return "";
  }
  String certificated = "https://";
  if (environment == "local") {
    certificated = "http://";
  }
  return "$certificated${prefs.getString('domain')!}/api";
}

Future<bool> isSetup() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getBool('setup') ?? false;
}

Future<void> storeSetup(String domain) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool('setup', true);
  await prefs.setString('domain', domain);
}
