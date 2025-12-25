import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bilal/providers/prayer_provider.dart';
import 'package:bilal/services/prayer_time_service.dart';
import 'package:bilal/services/notification_service.dart';

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
        backgroundColor: Colors.teal,
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
                  title: const Text('Atur Lokasi Manual'),
                  subtitle: const Text('Masukkan koordinat custom'),
                  leading: const Icon(Icons.edit_location),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _showLocationDialog(context, provider),
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
              color: Colors.teal.shade700,
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
                  ? const Icon(Icons.check, color: Colors.teal)
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

  void _showLocationDialog(BuildContext context, PrayerProvider provider) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Atur Lokasi Manual'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nama Lokasi',
                  hintText: 'Contoh: Jakarta',
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _latController,
                decoration: const InputDecoration(
                  labelText: 'Latitude',
                  hintText: 'Contoh: -6.2088',
                ),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                  signed: true,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _lngController,
                decoration: const InputDecoration(
                  labelText: 'Longitude',
                  hintText: 'Contoh: 106.8456',
                ),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                  signed: true,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                final lat = double.tryParse(_latController.text);
                final lng = double.tryParse(_lngController.text);
                final name = _nameController.text.trim();

                if (lat != null && lng != null && name.isNotEmpty) {
                  provider.setCustomLocation(lat, lng, name);
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Lokasi berhasil diubah')),
                  );
                  _latController.clear();
                  _lngController.clear();
                  _nameController.clear();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Mohon isi semua field dengan benar'),
                    ),
                  );
                }
              },
              child: const Text('Simpan'),
            ),
          ],
        );
      },
    );
  }
}
