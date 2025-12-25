import 'package:bilal/models/prayer_name.dart';

class PrayerTimesModel {
  final DateTime fajr;
  final DateTime sunrise;
  final DateTime dhuhr;
  final DateTime asr;
  final DateTime maghrib;
  final DateTime isha;
  final DateTime date;

  PrayerTimesModel({
    required this.fajr,
    required this.sunrise,
    required this.dhuhr,
    required this.asr,
    required this.maghrib,
    required this.isha,
    required this.date,
  });

  DateTime getTimeForPrayer(PrayerName prayer) {
    switch (prayer) {
      case PrayerName.fajr:
        return fajr;
      case PrayerName.sunrise:
        return sunrise;
      case PrayerName.dhuhr:
        return dhuhr;
      case PrayerName.asr:
        return asr;
      case PrayerName.maghrib:
        return maghrib;
      case PrayerName.isha:
        return isha;
    }
  }

  /// Get the next prayer time from current time
  PrayerName? getNextPrayer(DateTime now) {
    if (now.isBefore(fajr)) return PrayerName.fajr;
    if (now.isBefore(sunrise)) return PrayerName.sunrise;
    if (now.isBefore(dhuhr)) return PrayerName.dhuhr;
    if (now.isBefore(asr)) return PrayerName.asr;
    if (now.isBefore(maghrib)) return PrayerName.maghrib;
    if (now.isBefore(isha)) return PrayerName.isha;
    return null; // All prayers have passed for today
  }

  /// Get current prayer (the last prayer that has started)
  PrayerName? getCurrentPrayer(DateTime now) {
    if (now.isBefore(fajr)) return null;
    if (now.isBefore(sunrise)) return PrayerName.fajr;
    if (now.isBefore(dhuhr)) return PrayerName.sunrise;
    if (now.isBefore(asr)) return PrayerName.dhuhr;
    if (now.isBefore(maghrib)) return PrayerName.asr;
    if (now.isBefore(isha)) return PrayerName.maghrib;
    return PrayerName.isha;
  }

  /// Check if a specific prayer time has passed
  bool hasPassed(PrayerName prayer, DateTime now) {
    return now.isAfter(getTimeForPrayer(prayer));
  }
}
