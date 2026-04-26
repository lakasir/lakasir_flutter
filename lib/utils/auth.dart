import 'package:lakasir/config/app.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<String> checkAuthentication() async {
  final setup = await isSetup();
  final token = await getToken();
  if (setup && token != null) {
    return "menu";
  }

  if (setup && token == null) {
    if (await isOfflineAuthenticated()) {
      return "menu";
    }
    return "login";
  }

  if (!setup) {
    if (await isOfflineAuthenticated()) {
      return "menu";
    }
    return "setup";
  }

  return "setup";
}

Future<void> logout() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('token');
  await prefs.remove('permissions');
  await prefs.remove('offline_auth');
  await prefs.remove('offline_user_id');
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
  await logout();
  await prefs.setBool('setup', true);
  await prefs.setString('domain', domain);
}

bool can(List<String> permissions, {String? ability, String? feature}) {
  return permissions.contains(ability);
}

void destroySetup() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('setup');
  await prefs.remove('domain');
}

Future<void> storeOfflineUserId(int id) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setInt('offline_user_id', id);
}

Future<int?> getOfflineUserId() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getInt('offline_user_id');
}

Future<void> storeOfflineAuth(bool value) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool('offline_auth', value);
}

Future<bool> isOfflineAuthenticated() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getBool('offline_auth') ?? false;
}

Future<bool> isOfflineMode() async {
  return !(await isSetup());
}

Future<bool> hasDomain() async {
  final prefs = await SharedPreferences.getInstance();
  final setup = await isSetup();
  if (!setup) return false;
  final domain = prefs.getString('domain');
  return domain != null && domain.isNotEmpty;
}
