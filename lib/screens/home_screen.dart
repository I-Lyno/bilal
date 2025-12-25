import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:bilal/providers/prayer_provider.dart';
import 'package:bilal/widgets/prayer_time_card.dart';
import 'package:bilal/widgets/countdown_timer.dart';
import 'package:bilal/screens/settings_screen.dart';
import 'package:bilal/screens/qibla_screen.dart';
import 'package:bilal/models/prayer_name.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<PrayerProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading && provider.prayerTimes == null) {
            return _buildLoadingState();
          }

          if (provider.error != null && provider.prayerTimes == null) {
            return _buildErrorState(context, provider);
          }

          return RefreshIndicator(
            onRefresh: () => provider.refreshPrayerTimes(),
            child: CustomScrollView(
              slivers: [
                _buildAppBar(context, provider),
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      if (provider.timeUntilNextPrayer != null &&
                          provider.nextPrayer != null)
                        CountdownTimer(
                          duration: provider.timeUntilNextPrayer!,
                          label: 'Menuju ${provider.nextPrayer!.displayName}',
                        ),
                      const SizedBox(height: 16),
                      if (provider.prayerTimes != null)
                        _buildPrayerTimes(provider),
                      const SizedBox(height: 80),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'qibla',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const QiblaScreen()),
              );
            },
            backgroundColor: Colors.amber.shade700,
            child: const Icon(Icons.explore),
          ),
          const SizedBox(height: 16),
          FloatingActionButton(
            heroTag: 'settings',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SettingsScreen()),
              );
            },
            backgroundColor: Colors.teal,
            child: const Icon(Icons.settings),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, PrayerProvider provider) {
    return SliverAppBar(
      expandedHeight: 180,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.teal.shade600, Colors.teal.shade800],
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Jadwal Sholat',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        color: Colors.white70,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        provider.locationName ?? 'Memuat lokasi...',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    DateFormat(
                      'EEEE, dd MMMM yyyy',
                      'id_ID',
                    ).format(DateTime.now()),
                    style: const TextStyle(fontSize: 14, color: Colors.white70),
                  ),
                ],
              ),
            ),
          ),
        ),
        title: const Text('Bilal', style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      backgroundColor: Colors.teal.shade700,
    );
  }

  Widget _buildPrayerTimes(PrayerProvider provider) {
    final prayerTimes = provider.prayerTimes!;
    final now = DateTime.now();
    final nextPrayer = provider.nextPrayer;

    final prayers = [
      PrayerName.fajr,
      PrayerName.sunrise,
      PrayerName.dhuhr,
      PrayerName.asr,
      PrayerName.maghrib,
      PrayerName.isha,
    ];

    return Column(
      children: prayers.map((prayer) {
        final time = prayerTimes.getTimeForPrayer(prayer);
        final hasPassed = prayerTimes.hasPassed(prayer, now);
        final isNext = prayer == nextPrayer;

        return PrayerTimeCard(
          prayer: prayer,
          time: time,
          hasPassed: hasPassed,
          isNext: isNext,
        );
      }).toList(),
    );
  }

  Widget _buildLoadingState() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.teal.shade600, Colors.teal.shade800],
        ),
      ),
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: Colors.white),
            SizedBox(height: 24),
            Text(
              'Memuat waktu sholat...',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, PrayerProvider provider) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.teal.shade600, Colors.teal.shade800],
        ),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.white70),
              const SizedBox(height: 24),
              Text(
                provider.error ?? 'Terjadi kesalahan',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: () => provider.loadPrayerTimes(),
                icon: const Icon(Icons.refresh),
                label: const Text('Coba Lagi'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
