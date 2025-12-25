class IndonesianCity {
  final String name;
  final String province;
  final double latitude;
  final double longitude;

  const IndonesianCity({
    required this.name,
    required this.province,
    required this.latitude,
    required this.longitude,
  });
}

class IndonesianCities {
  static const List<IndonesianCity> cities = [
    // Sumatera
    IndonesianCity(
      name: 'Banda Aceh',
      province: 'Aceh',
      latitude: 5.5483,
      longitude: 95.3238,
    ),
    IndonesianCity(
      name: 'Medan',
      province: 'Sumatera Utara',
      latitude: 3.5952,
      longitude: 98.6722,
    ),
    IndonesianCity(
      name: 'Pekanbaru',
      province: 'Riau',
      latitude: 0.5071,
      longitude: 101.4478,
    ),
    IndonesianCity(
      name: 'Padang',
      province: 'Sumatera Barat',
      latitude: -0.9471,
      longitude: 100.4172,
    ),
    IndonesianCity(
      name: 'Jambi',
      province: 'Jambi',
      latitude: -1.6101,
      longitude: 103.6131,
    ),
    IndonesianCity(
      name: 'Palembang',
      province: 'Sumatera Selatan',
      latitude: -2.9761,
      longitude: 104.7754,
    ),
    IndonesianCity(
      name: 'Bengkulu',
      province: 'Bengkulu',
      latitude: -3.7928,
      longitude: 102.2608,
    ),
    IndonesianCity(
      name: 'Bandar Lampung',
      province: 'Lampung',
      latitude: -5.4292,
      longitude: 105.2619,
    ),
    IndonesianCity(
      name: 'Batam',
      province: 'Kepulauan Riau',
      latitude: 1.0456,
      longitude: 104.0305,
    ),

    // Jawa
    IndonesianCity(
      name: 'Jakarta',
      province: 'DKI Jakarta',
      latitude: -6.2088,
      longitude: 106.8456,
    ),
    IndonesianCity(
      name: 'Bogor',
      province: 'Jawa Barat',
      latitude: -6.5950,
      longitude: 106.7967,
    ),
    IndonesianCity(
      name: 'Depok',
      province: 'Jawa Barat',
      latitude: -6.4025,
      longitude: 106.7942,
    ),
    IndonesianCity(
      name: 'Tangerang',
      province: 'Banten',
      latitude: -6.1783,
      longitude: 106.6319,
    ),
    IndonesianCity(
      name: 'Bekasi',
      province: 'Jawa Barat',
      latitude: -6.2383,
      longitude: 106.9756,
    ),
    IndonesianCity(
      name: 'Bandung',
      province: 'Jawa Barat',
      latitude: -6.9175,
      longitude: 107.6191,
    ),
    IndonesianCity(
      name: 'Cirebon',
      province: 'Jawa Barat',
      latitude: -6.7063,
      longitude: 108.5571,
    ),
    IndonesianCity(
      name: 'Semarang',
      province: 'Jawa Tengah',
      latitude: -6.9667,
      longitude: 110.4167,
    ),
    IndonesianCity(
      name: 'Surakarta',
      province: 'Jawa Tengah',
      latitude: -7.5561,
      longitude: 110.8316,
    ),
    IndonesianCity(
      name: 'Magelang',
      province: 'Jawa Tengah',
      latitude: -7.4797,
      longitude: 110.2178,
    ),
    IndonesianCity(
      name: 'Salatiga',
      province: 'Jawa Tengah',
      latitude: -7.3320,
      longitude: 110.4920,
    ),
    IndonesianCity(
      name: 'Pekalongan',
      province: 'Jawa Tengah',
      latitude: -6.8886,
      longitude: 109.6753,
    ),
    IndonesianCity(
      name: 'Tegal',
      province: 'Jawa Tengah',
      latitude: -6.8694,
      longitude: 109.1402,
    ),
    IndonesianCity(
      name: 'Purwokerto',
      province: 'Jawa Tengah',
      latitude: -7.4246,
      longitude: 109.2379,
    ),
    IndonesianCity(
      name: 'Cilacap',
      province: 'Jawa Tengah',
      latitude: -7.7256,
      longitude: 109.0154,
    ),
    IndonesianCity(
      name: 'Purworejo',
      province: 'Jawa Tengah',
      latitude: -7.7161,
      longitude: 110.0089,
    ),
    IndonesianCity(
      name: 'Kebumen',
      province: 'Jawa Tengah',
      latitude: -7.6671,
      longitude: 109.6578,
    ),
    IndonesianCity(
      name: 'Klaten',
      province: 'Jawa Tengah',
      latitude: -7.7058,
      longitude: 110.6067,
    ),
    IndonesianCity(
      name: 'Boyolali',
      province: 'Jawa Tengah',
      latitude: -7.5303,
      longitude: 110.5958,
    ),
    IndonesianCity(
      name: 'Sukoharjo',
      province: 'Jawa Tengah',
      latitude: -7.6838,
      longitude: 110.8219,
    ),
    IndonesianCity(
      name: 'Wonogiri',
      province: 'Jawa Tengah',
      latitude: -7.8144,
      longitude: 110.9272,
    ),
    IndonesianCity(
      name: 'Karanganyar',
      province: 'Jawa Tengah',
      latitude: -7.6045,
      longitude: 110.9462,
    ),
    IndonesianCity(
      name: 'Sragen',
      province: 'Jawa Tengah',
      latitude: -7.4256,
      longitude: 111.0217,
    ),
    IndonesianCity(
      name: 'Kudus',
      province: 'Jawa Tengah',
      latitude: -6.8048,
      longitude: 110.8405,
    ),
    IndonesianCity(
      name: 'Jepara',
      province: 'Jawa Tengah',
      latitude: -6.5882,
      longitude: 110.6686,
    ),
    IndonesianCity(
      name: 'Demak',
      province: 'Jawa Tengah',
      latitude: -6.8906,
      longitude: 110.6396,
    ),
    IndonesianCity(
      name: 'Kendal',
      province: 'Jawa Tengah',
      latitude: -6.9264,
      longitude: 110.2031,
    ),
    IndonesianCity(
      name: 'Batang',
      province: 'Jawa Tengah',
      latitude: -6.9057,
      longitude: 109.7286,
    ),
    IndonesianCity(
      name: 'Pemalang',
      province: 'Jawa Tengah',
      latitude: -6.8984,
      longitude: 109.3781,
    ),
    IndonesianCity(
      name: 'Brebes',
      province: 'Jawa Tengah',
      latitude: -6.8730,
      longitude: 109.0424,
    ),
    IndonesianCity(
      name: 'Pati',
      province: 'Jawa Tengah',
      latitude: -6.7558,
      longitude: 111.0381,
    ),
    IndonesianCity(
      name: 'Rembang',
      province: 'Jawa Tengah',
      latitude: -6.7089,
      longitude: 111.3426,
    ),
    IndonesianCity(
      name: 'Blora',
      province: 'Jawa Tengah',
      latitude: -6.9698,
      longitude: 111.4195,
    ),
    IndonesianCity(
      name: 'Grobogan',
      province: 'Jawa Tengah',
      latitude: -7.0544,
      longitude: 110.9128,
    ),
    IndonesianCity(
      name: 'Temanggung',
      province: 'Jawa Tengah',
      latitude: -7.3150,
      longitude: 110.1708,
    ),
    IndonesianCity(
      name: 'Wonosobo',
      province: 'Jawa Tengah',
      latitude: -7.3606,
      longitude: 109.9019,
    ),
    IndonesianCity(
      name: 'Purbalingga',
      province: 'Jawa Tengah',
      latitude: -7.3881,
      longitude: 109.3668,
    ),
    IndonesianCity(
      name: 'Banjarnegara',
      province: 'Jawa Tengah',
      latitude: -7.3855,
      longitude: 109.6854,
    ),
    IndonesianCity(
      name: 'Yogyakarta',
      province: 'DI Yogyakarta',
      latitude: -7.7956,
      longitude: 110.3695,
    ),
    IndonesianCity(
      name: 'Surabaya',
      province: 'Jawa Timur',
      latitude: -7.2575,
      longitude: 112.7521,
    ),
    IndonesianCity(
      name: 'Malang',
      province: 'Jawa Timur',
      latitude: -7.9797,
      longitude: 112.6304,
    ),
    IndonesianCity(
      name: 'Serang',
      province: 'Banten',
      latitude: -6.1204,
      longitude: 106.1640,
    ),

    // Kalimantan
    IndonesianCity(
      name: 'Pontianak',
      province: 'Kalimantan Barat',
      latitude: -0.0263,
      longitude: 109.3425,
    ),
    IndonesianCity(
      name: 'Palangkaraya',
      province: 'Kalimantan Tengah',
      latitude: -2.2089,
      longitude: 113.9139,
    ),
    IndonesianCity(
      name: 'Banjarmasin',
      province: 'Kalimantan Selatan',
      latitude: -3.3194,
      longitude: 114.5906,
    ),
    IndonesianCity(
      name: 'Samarinda',
      province: 'Kalimantan Timur',
      latitude: -0.5022,
      longitude: 117.1536,
    ),
    IndonesianCity(
      name: 'Balikpapan',
      province: 'Kalimantan Timur',
      latitude: -1.2379,
      longitude: 116.8529,
    ),
    IndonesianCity(
      name: 'Tarakan',
      province: 'Kalimantan Utara',
      latitude: 3.3000,
      longitude: 117.6333,
    ),

    // Sulawesi
    IndonesianCity(
      name: 'Manado',
      province: 'Sulawesi Utara',
      latitude: 1.4748,
      longitude: 124.8421,
    ),
    IndonesianCity(
      name: 'Gorontalo',
      province: 'Gorontalo',
      latitude: 0.5435,
      longitude: 123.0672,
    ),
    IndonesianCity(
      name: 'Palu',
      province: 'Sulawesi Tengah',
      latitude: -0.8999,
      longitude: 119.8707,
    ),
    IndonesianCity(
      name: 'Makassar',
      province: 'Sulawesi Selatan',
      latitude: -5.1477,
      longitude: 119.4327,
    ),
    IndonesianCity(
      name: 'Kendari',
      province: 'Sulawesi Tenggara',
      latitude: -3.9450,
      longitude: 122.5989,
    ),
    IndonesianCity(
      name: 'Mamuju',
      province: 'Sulawesi Barat',
      latitude: -2.6747,
      longitude: 118.8917,
    ),

    // Bali & Nusa Tenggara
    IndonesianCity(
      name: 'Denpasar',
      province: 'Bali',
      latitude: -8.6500,
      longitude: 115.2167,
    ),
    IndonesianCity(
      name: 'Mataram',
      province: 'Nusa Tenggara Barat',
      latitude: -8.5833,
      longitude: 116.1167,
    ),
    IndonesianCity(
      name: 'Kupang',
      province: 'Nusa Tenggara Timur',
      latitude: -10.1718,
      longitude: 123.6075,
    ),

    // Maluku & Papua
    IndonesianCity(
      name: 'Ambon',
      province: 'Maluku',
      latitude: -3.6954,
      longitude: 128.1814,
    ),
    IndonesianCity(
      name: 'Ternate',
      province: 'Maluku Utara',
      latitude: 0.7896,
      longitude: 127.3686,
    ),
    IndonesianCity(
      name: 'Jayapura',
      province: 'Papua',
      latitude: -2.5920,
      longitude: 140.6687,
    ),
    IndonesianCity(
      name: 'Manokwari',
      province: 'Papua Barat',
      latitude: -0.8618,
      longitude: 134.0640,
    ),
  ];

  // Helper to get city by name
  static IndonesianCity? getCityByName(String name) {
    try {
      return cities.firstWhere((city) => city.name == name);
    } catch (e) {
      return null;
    }
  }

  // Search cities by name or province
  static List<IndonesianCity> searchCities(String query) {
    if (query.isEmpty) return cities;

    final lowerQuery = query.toLowerCase();
    return cities.where((city) {
      return city.name.toLowerCase().contains(lowerQuery) ||
          city.province.toLowerCase().contains(lowerQuery);
    }).toList();
  }

  // Group cities by province
  static Map<String, List<IndonesianCity>> getCitiesByProvince() {
    final Map<String, List<IndonesianCity>> grouped = {};
    for (var city in cities) {
      if (!grouped.containsKey(city.province)) {
        grouped[city.province] = [];
      }
      grouped[city.province]!.add(city);
    }
    return grouped;
  }
}
