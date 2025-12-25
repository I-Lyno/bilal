import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  static const String _keyLatitude = 'latitude';
  static const String _keyLongitude = 'longitude';
  static const String _keyCalculationMethod = 'calculation_method';
  static const String _keyNotificationsEnabled = 'notifications_enabled';
  static const String _keyDarkMode = 'dark_mode';
  static const String _keyLocationName = 'location_name';

  Future<void> saveLocation(
    double latitude,
    double longitude,
    String name,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_keyLatitude, latitude);
    await prefs.setDouble(_keyLongitude, longitude);
    await prefs.setString(_keyLocationName, name);
  }

  Future<Map<String, dynamic>?> getLocation() async {
    final prefs = await SharedPreferences.getInstance();
    final lat = prefs.getDouble(_keyLatitude);
    final lng = prefs.getDouble(_keyLongitude);
    final name = prefs.getString(_keyLocationName);

    if (lat == null || lng == null) return null;

    return {'latitude': lat, 'longitude': lng, 'name': name ?? 'Lokasi Saya'};
  }

  Future<void> saveCalculationMethod(String method) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyCalculationMethod, method);
  }

  Future<String> getCalculationMethod() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyCalculationMethod) ??
        'singapore'; // Default ke Kemenag Indonesia
  }

  Future<void> setNotificationsEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyNotificationsEnabled, enabled);
  }

  Future<bool> getNotificationsEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyNotificationsEnabled) ?? true;
  }

  Future<void> setDarkMode(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyDarkMode, enabled);
  }

  Future<bool> getDarkMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyDarkMode) ?? false;
  }
}
