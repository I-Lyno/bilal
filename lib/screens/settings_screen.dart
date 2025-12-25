import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bilal/providers/prayer_provider.dart';
import 'package:bilal/services/prayer_time_service.dart';
import 'package:bilal/services/notification_service.dart';
import 'package:bilal/models/indonesian_cities.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _latController = TextEditingController();
  final _lngController = TextEditingController();
  final _nameController = TextEditingController();

  @override
  void dispose() {
    _latController.dispose();
    _lngController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pengaturan'),
        backgroundColor: Colors.blue,
      ),
      body: Consumer<PrayerProvider>(
        builder: (context, provider, child) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildSection('Notifikasi', [
                SwitchListTile(
                  title: const Text('Aktifkan Notifikasi'),
                  subtitle: const Text('Terima pengingat waktu sholat'),
                  value: provider.notificationsEnabled,
                  onChanged: (value) {
                    provider.setNotificationsEnabled(value);
                  },
                ),
                ListTile(
                  title: const Text('Test Notifikasi'),
                  subtitle: const Text('Coba kirim notifikasi test'),
                  leading: const Icon(Icons.notifications_active),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () async {
                    await NotificationService().showTestNotification();
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Notifikasi test dikirim!'),
                        ),
                      );
                    }
                  },
                ),
              ]),
              const Divider(height: 32),
              _buildSection('Metode Perhitungan', [
                ListTile(
                  title: const Text('Pilih Metode'),
                  subtitle: Text(_getMethodName(provider.calculationMethod)),
                  leading: const Icon(Icons.calculate),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _showMethodPicker(context, provider),
                ),
              ]),
              const Divider(height: 32),
              _buildSection('Lokasi', [
                ListTile(
                  title: const Text('Lokasi Saat Ini'),
                  subtitle: Text(provider.locationName ?? 'Tidak ada'),
                  leading: const Icon(Icons.location_on),
                ),
                ListTile(
                  title: const Text('Pilih Kota'),
                  subtitle: const Text('Pilih dari daftar kota di Indonesia'),
                  leading: const Icon(Icons.location_city),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _showCityPicker(context, provider),
                ),
              ]),
              const Divider(height: 32),
              _buildSection('Tentang', [
                const ListTile(
                  title: Text('Versi Aplikasi'),
                  subtitle: Text('1.0.0'),
                  leading: Icon(Icons.info),
                ),
                const ListTile(
                  title: Text('Bilal - Pengingat Sholat'),
                  subtitle: Text(
                    'Aplikasi pengingat waktu sholat dengan perhitungan akurat berdasarkan lokasi Anda.',
                  ),
                  leading: Icon(Icons.app_settings_alt),
                ),
              ]),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.blue.shade700,
            ),
          ),
        ),
        Card(child: Column(children: children)),
      ],
    );
  }

  String _getMethodName(String method) {
    final methods = PrayerTimeService().getAvailableMethods();
    final found = methods.firstWhere(
      (m) => m['id'] == method,
      orElse: () => {'name': method},
    );
    return found['name'] ?? method;
  }

  void _showMethodPicker(BuildContext context, PrayerProvider provider) {
    final methods = PrayerTimeService().getAvailableMethods();

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return ListView.builder(
          shrinkWrap: true,
          itemCount: methods.length,
          itemBuilder: (context, index) {
            final method = methods[index];
            final isSelected = method['id'] == provider.calculationMethod;

            return ListTile(
              title: Text(method['name']!),
              subtitle: Text(method['description']!),
              trailing: isSelected
                  ? const Icon(Icons.check, color: Colors.blue)
                  : null,
              selected: isSelected,
              onTap: () {
                provider.setCalculationMethod(method['id']!);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Metode diubah ke ${method['name']}')),
                );
              },
            );
          },
        );
      },
    );
  }

  void _showCityPicker(BuildContext context, PrayerProvider provider) {
    String searchQuery = '';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            final filteredCities = IndonesianCities.searchCities(searchQuery);

            return DraggableScrollableSheet(
              initialChildSize: 0.9,
              minChildSize: 0.5,
              maxChildSize: 0.95,
              expand: false,
              builder: (context, scrollController) {
                return Column(
                  children: [
                    // Header
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade700,
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(20),
                        ),
                      ),
                      child: Column(
                        children: [
                          const Text(
                            'Pilih Kota',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 12),
                          TextField(
                            decoration: InputDecoration(
                              hintText: 'Cari kota atau provinsi...',
                              prefixIcon: const Icon(Icons.search),
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            onChanged: (value) {
                              setState(() {
                                searchQuery = value;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    // City list
                    Expanded(
                      child: filteredCities.isEmpty
                          ? const Center(
                              child: Text('Tidak ada kota ditemukan'),
                            )
                          : ListView.builder(
                              controller: scrollController,
                              itemCount: filteredCities.length,
                              itemBuilder: (context, index) {
                                final city = filteredCities[index];
                                return ListTile(
                                  leading: CircleAvatar(
                                    backgroundColor: Colors.blue.shade100,
                                    child: Icon(
                                      Icons.location_city,
                                      color: Colors.blue.shade700,
                                    ),
                                  ),
                                  title: Text(
                                    city.name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  subtitle: Text(city.province),
                                  onTap: () {
                                    provider.setCustomLocation(
                                      city.latitude,
                                      city.longitude,
                                      '${city.name}, ${city.province}',
                                    );
                                    Navigator.pop(context);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'Lokasi diubah ke ${city.name}',
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                    ),
                  ],
                );
              },
            );
          },
        );
      },
    );
  }
}
