import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  Future<void> setLoggedInUser(String user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('loggedInUser', user);
    await prefs.setString('loginTime', DateTime.now().toIso8601String());
  }

  Future<void> setLogoutTime() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('logoutTime', DateTime.now().toIso8601String());
  }

  Future<String?> getLoggedInUser() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('loggedInUser');
  }

  Future<String?> getLoginTime() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('loginTime');
  }

  Future<String?> getLogoutTime() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('logoutTime');
  }

  Future<void> clearLoggedInUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('loggedInUser');
    await prefs.remove('loginTime');
    await prefs.remove('logoutTime');
  }
}
