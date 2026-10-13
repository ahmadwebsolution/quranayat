import 'package:flutter/material.dart';

class AppConstants {
  // App Info
  static const String appTitle = 'Quran Ayat • Audio Book';

  // Sample Assets & URLs requested by User
  static const String defaultAyahPngUrl = 'https://everyayah.com/data/images_png/1_1.png';
  static const String defaultAyahAudioUrl =
      'https://everyayah.com/data/Abdul_Basit_Murattal_64kbps/001001.mp3';

  // Base URLs for EveryAyah
  static const String ayahImageBaseUrl = 'https://everyayah.com/data/images_png';
  static const String ayahAudioBaseUrl =
      'https://everyayah.com/data/Abdul_Basit_Murattal_64kbps';

  // Database
  static const String dbName = 'quran_audiobook.db';
  static const int dbVersion = 2;
  static const String tableNameAyahs = 'ayahs';

  // Futuristic Antigravity Color Palette
  static const Color bgDark = Color(0xFF070B12);
  static const Color bgCard = Color(0xFF0F1726);
  static const Color bgCardSecondary = Color(0xFF162136);

  // Glowing Gold Accents
  static const Color goldLight = Color(0xFFFFE699);
  static const Color goldPrimary = Color(0xFFFFD15C);
  static const Color goldAccent = Color(0xFFE5A93C);
  static const Color goldDark = Color(0xFF996B1E);

  // Neon & Ambient Glow
  static const Color glowCyan = Color(0xFF38E1FF);
  static const Color textMuted = Color(0xFF8F9FB3);
  static const Color textWhite = Color(0xFFF3F6FA);

  // Gradients
  static const LinearGradient goldGradient = LinearGradient(
    colors: [goldLight, goldPrimary, goldAccent],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cosmicGradient = LinearGradient(
    colors: [Color(0xFF05080E), Color(0xFF0B111D), Color(0xFF090D17)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient cardGlowGradient = LinearGradient(
    colors: [
      Color(0x28FFD15C),
      Color(0x0A0F1726),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
