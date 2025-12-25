import 'dart:async';
import 'package:flutter/material.dart';
import 'package:bilal/models/prayer_times_model.dart';
import 'package:bilal/models/prayer_name.dart';
import 'package:bilal/services/prayer_time_service.dart';
import 'package:bilal/services/location_service.dart';
import 'package:bilal/services/preferences_service.dart';
import 'package:bilal/services/notification_service.dart';

class PrayerProvider extends ChangeNotifier {
  final PrayerTimeService _prayerService = PrayerTimeService();
  final LocationService _locationService = LocationService();
  final PreferencesService _prefsService = PreferencesService();
  final NotificationService _notificationService = NotificationService();

  PrayerTimesModel? _prayerTimes;
  PrayerTimesModel? get prayerTimes => _prayerTimes;

  String? _locationName;
  String? get locationName => _locationName;

  double? _latitude;
  double? _longitude;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  Timer? _countdownTimer;
  Duration? _timeUntilNextPrayer;
  Duration? get timeUntilNextPrayer => _timeUntilNextPrayer;

  PrayerName? _nextPrayer;
  PrayerName? get nextPrayer => _nextPrayer;

  bool _notificationsEnabled = true;
  bool get notificationsEnabled => _notificationsEnabled;

  String _calculationMethod = 'singapore';
  String get calculationMethod => _calculationMethod;

  PrayerProvider() {
    _init();
  }

  Future<void> _init() async {
    await _loadPreferences();
    await _initializeNotifications();
    await loadPrayerTimes();
    _startCountdownTimer();
  }

  Future<void> _loadPreferences() async {
    _notificationsEnabled = await _prefsService.getNotificationsEnabled();
    _calculationMethod = await _prefsService.getCalculationMethod();
  }

  Future<void> _initializeNotifications() async {
    await _notificationService.initialize();
    if (_notificationsEnabled) {
      await _notificationService.requestPermission();
    }
  }

  /// Load prayer times from saved location or GPS
  Future<void> loadPrayerTimes() async {
    _setLoading(true);
    _error = null;

    try {
      // Try to get saved location first
      final savedLocation = await _prefsService.getLocation();

      if (savedLocation != null) {
        _latitude = savedLocation['latitude'];
        _longitude = savedLocation['longitude'];
        _locationName = savedLocation['name'];
      } else {
        // Get current location from GPS
        final position = await _locationService.getCurrentLocationWithTimeout();

        if (position == null) {
          // Use default location (Jakarta, Indonesia) for web/fallback
          print('GPS not available, using default location: Jakarta');
          _latitude = -6.2088; // Jakarta latitude
          _longitude = 106.8456; // Jakarta longitude
          _locationName = 'Jakarta, Indonesia (Default)';

          // Save default location
          await _prefsService.saveLocation(
            _latitude!,
            _longitude!,
            _locationName!,
          );
        } else {
          _latitude = position.latitude;
          _longitude = position.longitude;
          _locationName = 'Lokasi Saya';

          // Save location
          await _prefsService.saveLocation(
            position.latitude,
            position.longitude,
            _locationName!,
          );
        }
      }

      // Calculate prayer times
      _prayerTimes = _prayerService.calculatePrayerTimes(
        latitude: _latitude!,
        longitude: _longitude!,
        date: DateTime.now(),
        method: _calculationMethod,
      );

      // Update next prayer
      _updateNextPrayer();

      // Schedule notifications if enabled
      if (_notificationsEnabled && _prayerTimes != null) {
        await _notificationService.schedulePrayerNotifications(_prayerTimes!);
      }
    } catch (e) {
      _error = 'Terjadi kesalahan: $e';
      print('Error loading prayer times: $e');
    } finally {
      _setLoading(false);
    }
  }

  /// Refresh prayer times (pull to refresh)
  Future<void> refreshPrayerTimes() async {
    _setLoading(true);

    try {
      // Get fresh location
      final position = await _locationService.getCurrentLocationWithTimeout();

      if (position != null) {
        _latitude = position.latitude;
        _longitude = position.longitude;

        await _prefsService.saveLocation(
          position.latitude,
          position.longitude,
          _locationName ?? 'Lokasi Saya',
        );
      }

      if (_latitude != null && _longitude != null) {
        _prayerTimes = _prayerService.calculatePrayerTimes(
          latitude: _latitude!,
          longitude: _longitude!,
          date: DateTime.now(),
          method: _calculationMethod,
        );

        _updateNextPrayer();

        if (_notificationsEnabled && _prayerTimes != null) {
          await _notificationService.schedulePrayerNotifications(_prayerTimes!);
        }

        _error = null;
      }
    } catch (e) {
      _error = 'Gagal memperbarui: $e';
    } finally {
      _setLoading(false);
    }
  }

  /// Set custom location (from settings)
  Future<void> setCustomLocation(
    double latitude,
    double longitude,
    String name,
  ) async {
    _latitude = latitude;
    _longitude = longitude;
    _locationName = name;

    await _prefsService.saveLocation(latitude, longitude, name);
    await loadPrayerTimes();
  }

  /// Update calculation method
  Future<void> setCalculationMethod(String method) async {
    _calculationMethod = method;
    await _prefsService.saveCalculationMethod(method);
    await loadPrayerTimes();
  }

  /// Toggle notifications
  Future<void> setNotificationsEnabled(bool enabled) async {
    _notificationsEnabled = enabled;
    await _prefsService.setNotificationsEnabled(enabled);

    if (enabled) {
      await _notificationService.requestPermission();
      if (_prayerTimes != null) {
        await _notificationService.schedulePrayerNotifications(_prayerTimes!);
      }
    } else {
      await _notificationService.cancelAllNotifications();
    }

    notifyListeners();
  }

  /// Start countdown timer
  void _startCountdownTimer() {
    _countdownTimer?.cancel();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _updateNextPrayer();
    });
  }

  /// Update next prayer and countdown
  void _updateNextPrayer() {
    if (_prayerTimes == null) return;

    final now = DateTime.now();
    _nextPrayer = _prayerTimes!.getNextPrayer(now);

    if (_nextPrayer != null) {
      final nextPrayerTime = _prayerTimes!.getTimeForPrayer(_nextPrayer!);
      _timeUntilNextPrayer = nextPrayerTime.difference(now);
    } else {
      // All prayers passed, show time until tomorrow's Fajr
      final tomorrow = DateTime.now().add(const Duration(days: 1));
      final tomorrowPrayer = _prayerService.calculatePrayerTimes(
        latitude: _latitude!,
        longitude: _longitude!,
        date: tomorrow,
        method: _calculationMethod,
      );
      _timeUntilNextPrayer = tomorrowPrayer.fajr.difference(now);
      _nextPrayer = PrayerName.fajr;
    }

    notifyListeners();
  }

  /// Get Qibla direction
  double? getQiblaDirection() {
    if (_latitude == null || _longitude == null) return null;
    return _prayerService.calculateQiblaDirection(_latitude!, _longitude!);
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    super.dispose();
  }
}
