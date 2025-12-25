import 'package:adhan/adhan.dart';
import 'package:bilal/models/prayer_times_model.dart';

class PrayerTimeService {
  /// Calculate prayer times for given coordinates and date
  PrayerTimesModel calculatePrayerTimes({
    required double latitude,
    required double longitude,
    required DateTime date,
    String method = 'singapore', // Default: Kemenag Indonesia
  }) {
    // Create coordinates
    final coordinates = Coordinates(latitude, longitude);

    // Get calculation parameters based on method
    final params = _getCalculationParameters(method);

    // Calculate prayer times
    final prayerTimes = PrayerTimes(
      coordinates,
      DateComponents.from(date),
      params,
    );

    return PrayerTimesModel(
      fajr: prayerTimes.fajr,
      sunrise: prayerTimes.sunrise,
      dhuhr: prayerTimes.dhuhr,
      asr: prayerTimes.asr,
      maghrib: prayerTimes.maghrib,
      isha: prayerTimes.isha,
      date: date,
    );
  }

  /// Get calculation parameters based on method name
  CalculationParameters _getCalculationParameters(String method) {
    switch (method.toLowerCase()) {
      case 'singapore':
        return CalculationMethod.singapore.getParameters();
      case 'muslim_world_league':
        return CalculationMethod.muslim_world_league.getParameters();
      case 'egyptian':
        return CalculationMethod.egyptian.getParameters();
      case 'karachi':
        return CalculationMethod.karachi.getParameters();
      case 'umm_al_qura':
        return CalculationMethod.umm_al_qura.getParameters();
      case 'dubai':
        return CalculationMethod.dubai.getParameters();
      case 'qatar':
        return CalculationMethod.qatar.getParameters();
      case 'kuwait':
        return CalculationMethod.kuwait.getParameters();
      case 'moon_sighting_committee':
        return CalculationMethod.moon_sighting_committee.getParameters();
      case 'north_america':
        return CalculationMethod.north_america.getParameters();
      case 'tehran':
        return CalculationMethod.tehran.getParameters();
      case 'turkey':
        return CalculationMethod.turkey.getParameters();
      default:
        // Default to Singapore (close to Indonesia calculation)
        return CalculationMethod.singapore.getParameters();
    }
  }

  /// Get list of available calculation methods
  List<Map<String, String>> getAvailableMethods() {
    return [
      {
        'id': 'singapore',
        'name': 'Singapura (Kemenag RI)',
        'description': 'Direkomendasikan untuk Indonesia',
      },
      {
        'id': 'muslim_world_league',
        'name': 'Muslim World League',
        'description': 'Standar internasional',
      },
      {
        'id': 'egyptian',
        'name': 'Egyptian General Authority',
        'description': 'Mesir',
      },
      {
        'id': 'karachi',
        'name': 'University of Islamic Sciences, Karachi',
        'description': 'Pakistan',
      },
      {
        'id': 'umm_al_qura',
        'name': 'Umm Al-Qura University',
        'description': 'Saudi Arabia',
      },
      {'id': 'dubai', 'name': 'Dubai', 'description': 'UAE'},
      {'id': 'qatar', 'name': 'Qatar', 'description': 'Qatar'},
      {'id': 'kuwait', 'name': 'Kuwait', 'description': 'Kuwait'},
      {
        'id': 'moon_sighting_committee',
        'name': 'Moonsighting Committee',
        'description': 'Amerika Utara',
      },
      {
        'id': 'north_america',
        'name': 'ISNA',
        'description': 'Islamic Society of North America',
      },
      {'id': 'tehran', 'name': 'Tehran', 'description': 'Iran'},
      {'id': 'turkey', 'name': 'Turkey', 'description': 'Turki'},
    ];
  }

  /// Calculate Qibla direction from coordinates
  double calculateQiblaDirection(double latitude, double longitude) {
    final coordinates = Coordinates(latitude, longitude);
    final qibla = Qibla(coordinates);
    return qibla.direction;
  }
}
