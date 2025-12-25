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

  @override
  Widget build(BuildContext context) {
    final timeFormat = DateFormat('HH:mm');

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        gradient: isNext
            ? LinearGradient(
                colors: [Colors.green.shade400, Colors.green.shade600],
              )
            : hasPassed
            ? LinearGradient(
                colors: [Colors.grey.shade300, Colors.grey.shade400],
              )
            : LinearGradient(
                colors: [Colors.blue.shade50, Colors.blue.shade100],
              ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: isNext
            ? [
                BoxShadow(
                  color: Colors.green.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Icon
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: isNext || hasPassed
                    ? Colors.white.withOpacity(0.3)
                    : Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(prayer.icon, style: const TextStyle(fontSize: 28)),
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
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isNext || hasPassed
                          ? Colors.white
                          : Colors.grey.shade800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  if (isNext)
                    Text(
                      'Selanjutnya',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    )
                  else if (hasPassed)
                    Text(
                      'Sudah Lewat',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                ],
              ),
            ),

            // Time
            Text(
              timeFormat.format(time),
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: isNext || hasPassed
                    ? Colors.white
                    : Colors.grey.shade800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
