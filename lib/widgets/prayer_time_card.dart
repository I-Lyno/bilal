import 'package:flutter/material.dart';
import 'package:bilal/models/prayer_name.dart';
import 'package:intl/intl.dart';

class PrayerTimeCard extends StatelessWidget {
  final PrayerName prayer;
  final DateTime time;
  final bool hasPassed;
  final bool isNext;

  const PrayerTimeCard({
    super.key,
    required this.prayer,
    required this.time,
    required this.hasPassed,
    required this.isNext,
  });

  IconData _getPrayerIcon(PrayerName prayer) {
    switch (prayer) {
      case PrayerName.fajr:
        return Icons.wb_twilight;
      case PrayerName.sunrise:
        return Icons.wb_sunny;
      case PrayerName.dhuhr:
        return Icons.light_mode;
      case PrayerName.asr:
        return Icons.wb_cloudy;
      case PrayerName.maghrib:
        return Icons.nights_stay;
      case PrayerName.isha:
        return Icons.dark_mode;
    }
  }

  @override
  Widget build(BuildContext context) {
    final timeFormat = DateFormat('HH:mm');

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        gradient: isNext
            ? LinearGradient(
                colors: [Colors.green.shade400, Colors.green.shade600],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : hasPassed
            ? LinearGradient(
                colors: [Colors.grey.shade200, Colors.grey.shade300],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : LinearGradient(
                colors: [Colors.white, Colors.grey.shade50],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: isNext
                ? Colors.green.withOpacity(0.4)
                : Colors.black.withOpacity(0.08),
            blurRadius: isNext ? 12 : 6,
            offset: Offset(0, isNext ? 4 : 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Row(
              children: [
                // Icon with circular background
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: isNext || hasPassed
                        ? Colors.white.withOpacity(0.25)
                        : Colors.blue.shade50,
                    shape: BoxShape.circle,
                    boxShadow: [
                      if (!hasPassed && !isNext)
                        BoxShadow(
                          color: Colors.blue.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                    ],
                  ),
                  child: Icon(
                    _getPrayerIcon(prayer),
                    size: 30,
                    color: isNext || hasPassed
                        ? Colors.white
                        : Colors.blue.shade700,
                  ),
                ),
                const SizedBox(width: 16),

                // Prayer name and status
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        prayer.displayName,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: isNext || hasPassed
                              ? Colors.white
                              : Colors.grey.shade900,
                          letterSpacing: 0.3,
                        ),
                      ),
                      const SizedBox(height: 4),
                      if (isNext)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'Selanjutnya',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: Colors.white.withOpacity(0.95),
                              letterSpacing: 0.5,
                            ),
                          ),
                        )
                      else if (hasPassed)
                        Row(
                          children: [
                            Icon(
                              Icons.check_circle,
                              size: 14,
                              color: Colors.white.withOpacity(0.8),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Sudah Lewat',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white.withOpacity(0.85),
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),

                // Time with better typography
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      timeFormat.format(time),
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: isNext || hasPassed
                            ? Colors.white
                            : Colors.grey.shade900,
                        letterSpacing: -0.5,
                      ),
                    ),
                    if (!hasPassed && !isNext)
                      Text(
                        'WIB',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey.shade500,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
