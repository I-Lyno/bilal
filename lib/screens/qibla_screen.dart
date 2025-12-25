import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:provider/provider.dart';
import 'package:bilal/providers/prayer_provider.dart';

class QiblaScreen extends StatelessWidget {
  const QiblaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kompas Kiblat'),
        backgroundColor: Colors.amber.shade700,
      ),
      body: Consumer<PrayerProvider>(
        builder: (context, provider, child) {
          final qiblaDirection = provider.getQiblaDirection();

          if (qiblaDirection == null) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'Lokasi belum tersedia',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          return StreamBuilder<CompassEvent>(
            stream: FlutterCompass.events,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              final direction = snapshot.data?.heading;

              if (direction == null) {
                return const Center(
                  child: Text(
                    'Kompas tidak tersedia di perangkat ini',
                    textAlign: TextAlign.center,
                  ),
                );
              }

              // Calculate the angle to rotate the compass
              // Qibla direction - current heading
              final qiblaAngle = qiblaDirection - direction;

              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 32),
                    const Text(
                      'ARAH KIBLAT',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${qiblaDirection.toStringAsFixed(1)}°',
                      style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: Colors.amber.shade700,
                      ),
                    ),
                    const Text(
                      'dari Utara',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    const SizedBox(height: 48),

                    // Compass
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        // Compass ring
                        Transform.rotate(
                          angle: -direction * (math.pi / 180),
                          child: Container(
                            width: 300,
                            height: 300,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.grey.shade300,
                                width: 2,
                              ),
                            ),
                            child: Stack(
                              children: [
                                // North indicator
                                Positioned(
                                  top: 8,
                                  left: 0,
                                  right: 0,
                                  child: Center(
                                    child: Text(
                                      'N',
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.red.shade700,
                                      ),
                                    ),
                                  ),
                                ),
                                // East
                                Positioned(
                                  right: 8,
                                  top: 0,
                                  bottom: 0,
                                  child: Center(
                                    child: Text(
                                      'E',
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.grey.shade700,
                                      ),
                                    ),
                                  ),
                                ),
                                // South
                                Positioned(
                                  bottom: 8,
                                  left: 0,
                                  right: 0,
                                  child: Center(
                                    child: Text(
                                      'S',
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.grey.shade700,
                                      ),
                                    ),
                                  ),
                                ),
                                // West
                                Positioned(
                                  left: 8,
                                  top: 0,
                                  bottom: 0,
                                  child: Center(
                                    child: Text(
                                      'W',
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.grey.shade700,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Qibla direction arrow
                        Transform.rotate(
                          angle: qiblaAngle * (math.pi / 180),
                          child: Icon(
                            Icons.arrow_upward,
                            size: 120,
                            color: Colors.amber.shade700,
                          ),
                        ),

                        // Center dot
                        Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            color: Colors.amber.shade700,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 48),

                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 32),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.amber.shade50,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.info_outline, color: Colors.amber),
                          SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Putar perangkat hingga panah menunjuk ke atas untuk menghadap kiblat',
                              style: TextStyle(fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
