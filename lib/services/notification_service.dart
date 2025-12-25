import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:bilal/models/prayer_times_model.dart';
import 'package:bilal/models/prayer_name.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  bool _initialized = false;

  /// Initialize notification service
  Future<void> initialize() async {
    if (_initialized) return;

    // Initialize timezone
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Asia/Jakarta'));

    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTap,
    );

    _initialized = true;
  }

  /// Handle notification tap
  void _onNotificationTap(NotificationResponse response) {
    // Handle notification tap - can be used to navigate to specific screen
    print('Notification tapped: ${response.payload}');
  }

  /// Request notification permission
  Future<bool> requestPermission() async {
    if (!_initialized) await initialize();

    final androidPlugin = _notifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    if (androidPlugin != null) {
      final granted = await androidPlugin.requestNotificationsPermission();
      return granted ?? false;
    }

    final iosPlugin = _notifications
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >();

    if (iosPlugin != null) {
      final granted = await iosPlugin.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
      return granted ?? false;
    }

    return true;
  }

  /// Schedule notifications for all prayer times
  Future<void> schedulePrayerNotifications(PrayerTimesModel prayerTimes) async {
    if (!_initialized) await initialize();

    // Cancel all existing notifications
    await cancelAllNotifications();

    // Schedule for each prayer
    await _scheduleNotification(
      id: 1,
      title: 'Waktu Subuh',
      body: 'Saatnya sholat Subuh',
      scheduledTime: prayerTimes.fajr,
      prayer: PrayerName.fajr,
    );

    await _scheduleNotification(
      id: 2,
      title: 'Waktu Dzuhur',
      body: 'Saatnya sholat Dzuhur',
      scheduledTime: prayerTimes.dhuhr,
      prayer: PrayerName.dhuhr,
    );

    await _scheduleNotification(
      id: 3,
      title: 'Waktu Ashar',
      body: 'Saatnya sholat Ashar',
      scheduledTime: prayerTimes.asr,
      prayer: PrayerName.asr,
    );

    await _scheduleNotification(
      id: 4,
      title: 'Waktu Maghrib',
      body: 'Saatnya sholat Maghrib',
      scheduledTime: prayerTimes.maghrib,
      prayer: PrayerName.maghrib,
    );

    await _scheduleNotification(
      id: 5,
      title: 'Waktu Isya',
      body: 'Saatnya sholat Isya',
      scheduledTime: prayerTimes.isha,
      prayer: PrayerName.isha,
    );
  }

  /// Schedule a single notification
  Future<void> _scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledTime,
    required PrayerName prayer,
  }) async {
    // Only schedule if time is in the future
    if (scheduledTime.isBefore(DateTime.now())) {
      return;
    }

    // Use custom adzan sound - changed channel ID to force new channel creation
    const androidDetails = AndroidNotificationDetails(
      'prayer_times_v2', // Changed from prayer_times to create new channel
      'Waktu Sholat',
      channelDescription: 'Notifikasi waktu sholat dengan adzan',
      importance: Importance.max,
      priority: Priority.high,
      sound: RawResourceAndroidNotificationSound('adzan'),
      playSound: true,
      enableVibration: true,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      sound: 'adzan.mp3',
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notifications.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(scheduledTime, tz.local),
      details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      payload: prayer.name,
    );
  }

  /// Show immediate notification (for testing)
  Future<void> showTestNotification() async {
    if (!_initialized) await initialize();

    const androidDetails = AndroidNotificationDetails(
      'prayer_times_v2', // Use same channel as prayer notifications
      'Waktu Sholat',
      channelDescription: 'Notifikasi waktu sholat dengan adzan',
      importance: Importance.max,
      priority: Priority.high,
      sound: RawResourceAndroidNotificationSound('adzan'),
      playSound: true,
      enableVibration: true,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      sound: 'adzan.mp3',
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notifications.show(
      0,
      'Test Notifikasi 🕌',
      'Ini adalah test sound adzan untuk notifikasi sholat',
      details,
    );
  }

  /// Cancel all notifications
  Future<void> cancelAllNotifications() async {
    await _notifications.cancelAll();
  }

  /// Get pending notifications
  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    return await _notifications.pendingNotificationRequests();
  }
}
