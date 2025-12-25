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
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FloatingActionButton.extended(
            heroTag: 'qibla',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const QiblaScreen()),
              );
            },
            backgroundColor: Colors.amber.shade700,
            icon: const Icon(Icons.explore, size: 22),
            label: const Text(
              'Kiblat',
              style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 0.5),
            ),
            elevation: 6,
          ),
          const SizedBox(height: 12),
          FloatingActionButton.extended(
            heroTag: 'settings',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SettingsScreen()),
              );
            },
            backgroundColor: Colors.blue.shade600,
            icon: const Icon(Icons.settings_rounded, size: 22),
            label: const Text(
              'Pengaturan',
              style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 0.5),
            ),
            elevation: 6,
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, PrayerProvider provider) {
    return SliverAppBar(
      expandedHeight: 200,
      floating: false,
      pinned: true,
      elevation: 0,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.blue.shade600, Colors.blue.shade800],
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.mosque,
                        color: Colors.white.withOpacity(0.95),
                        size: 28,
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'Jadwal Sholat',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_rounded,
                        color: Colors.white.withOpacity(0.85),
                        size: 18,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          provider.locationName ?? 'Memuat lokasi...',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.white.withOpacity(0.9),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today_rounded,
                        color: Colors.white.withOpacity(0.85),
                        size: 16,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        DateFormat(
                          'EEEE, dd MMMM yyyy',
                          'id_ID',
                        ).format(DateTime.now()),
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white.withOpacity(0.85),
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
      ),
      backgroundColor: Colors.blue.shade700,
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
          colors: [Colors.blue.shade600, Colors.blue.shade800],
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
          colors: [Colors.blue.shade600, Colors.blue.shade800],
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
