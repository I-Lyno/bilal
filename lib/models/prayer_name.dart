enum PrayerName {
  fajr,
  sunrise,
  dhuhr,
  asr,
  maghrib,
  isha;

  String get displayName {
    switch (this) {
      case PrayerName.fajr:
        return 'Subuh';
      case PrayerName.sunrise:
        return 'Terbit';
      case PrayerName.dhuhr:
        return 'Dzuhur';
      case PrayerName.asr:
        return 'Ashar';
      case PrayerName.maghrib:
        return 'Maghrib';
      case PrayerName.isha:
        return 'Isya';
    }
  }

  String get icon {
    switch (this) {
      case PrayerName.fajr:
        return '🌅';
      case PrayerName.sunrise:
        return '☀️';
      case PrayerName.dhuhr:
        return '🌞';
      case PrayerName.asr:
        return '🌤️';
      case PrayerName.maghrib:
        return '🌆';
      case PrayerName.isha:
        return '🌙';
    }
  }
}
