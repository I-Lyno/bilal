# Setup Sound Adzan untuk Notifikasi

## Langkah-langkah:

### 1. Download File Adzan
Download file adzan dalam format MP3 dari sumber yang legal, misalnya:
- YouTube (convert to MP3)
- Islamic audio websites
- Atau gunakan recorder untuk merekam adzan

**Rekomendasi**: Cari "adzan merdu mp3" di Google

### 2. Rename File
- Rename file menjadi: `adzan.mp3`
- Lowercase, tanpa spasi
- Format: MP3

### 3. Copy ke Project
Copy file `adzan.mp3` ke folder:
```
/home/iqbal/project/flutter/bilal/android/app/src/main/res/raw/adzan.mp3
```

Folder `raw` sudah dibuat otomatis.

### 4. Rebuild App
Setelah file ditambahkan, jalankan:
```bash
flutter clean
flutter pub get
flutter run
```

### 5. Test Notifikasi
- Buka Settings di app
- Tap "Test Notifikasi"
- Sound adzan akan diputar

## File Size Recommendation
- Maksimal: 1-2 MB
- Duration: 30-60 detik (cukup untuk notification)
- Quality: 128kbps sudah cukup

## Alternative: Default Sound
Jika tidak ingin custom sound, notification akan menggunakan default system sound (sudah aktif sekarang).
