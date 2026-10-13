import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_common_ffi.dart'
    show sqfliteFfiInit, databaseFactoryFfi;
import '../constants.dart';
import '../../models/ayah.dart';

class AppDatabase {
  static final AppDatabase instance = AppDatabase._init();
  static Database? _database;
  static List<Ayah>? _memoryFallback;

  AppDatabase._init();

  Future<Database?> get database async {
    if (_database != null) return _database;
    try {
      _database = await _initDB(AppConstants.dbName);
      return _database;
    } catch (e) {
      debugPrint('Database initialization warning: $e. Falling back to in-memory store.');
      return null;
    }
  }

  Future<Database?> _initDB(String filePath) async {
    if (kIsWeb) {
      return null;
    }

    if (Platform.isWindows || Platform.isLinux) {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }

    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: AppConstants.dbVersion,
      onCreate: _createDB,
      onUpgrade: _onUpgradeDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE ${AppConstants.tableNameAyahs} (
        id INTEGER PRIMARY KEY,
        surah_number INTEGER NOT NULL,
        ayah_number INTEGER NOT NULL,
        surah_name_arabic TEXT,
        surah_name_english TEXT,
        text_arabic TEXT,
        translation TEXT,
        image_url TEXT,
        audio_url TEXT,
        is_favorite INTEGER NOT NULL DEFAULT 0
      )
    ''');

    for (final ayah in initialAyahsSeed) {
      await db.insert(AppConstants.tableNameAyahs, ayah.toMap());
    }
  }

  Future<void> _onUpgradeDB(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // Re-seed clean audio URLs while preserving user favorite bookmarks
      final existing = await db.query(AppConstants.tableNameAyahs);
      final favoriteIds = existing
          .where((m) => m['is_favorite'] == 1)
          .map((m) => m['id'] as int)
          .toSet();

      await db.delete(AppConstants.tableNameAyahs);
      for (final ayah in initialAyahsSeed) {
        final isFav = favoriteIds.contains(ayah.id);
        await db.insert(
          AppConstants.tableNameAyahs,
          ayah.copyWith(isFavorite: isFav).toMap(),
        );
      }
    }
  }

  static final List<Ayah> initialAyahsSeed = [
    const Ayah(
      id: 1,
      surahNumber: 1,
      ayahNumber: 1,
      surahNameArabic: 'الفاتحة',
      surahNameEnglish: 'Al-Fatihah',
      textArabic: 'بِسْمِ ٱللَّهِ ٱلرَّحْمَـٰنِ ٱلرَّحِيمِ',
      translation: 'In the name of Allah, the Entirely Merciful, the Especially Merciful.',
      imageUrl: AppConstants.defaultAyahPngUrl,
      audioUrl: AppConstants.defaultAyahAudioUrl,
    ),
    const Ayah(
      id: 2,
      surahNumber: 1,
      ayahNumber: 2,
      surahNameArabic: 'الفاتحة',
      surahNameEnglish: 'Al-Fatihah',
      textArabic: 'ٱلْحَمْدُ لِلَّهِ رَبِّ ٱلْعَـٰلَمِينَ',
      translation: '[All] praise is [due] to Allah, Lord of the worlds -',
      imageUrl: 'https://everyayah.com/data/images_png/1_2.png',
      audioUrl: 'https://everyayah.com/data/Abdul_Basit_Murattal_64kbps/001002.mp3',
    ),
    const Ayah(
      id: 3,
      surahNumber: 1,
      ayahNumber: 3,
      surahNameArabic: 'الفاتحة',
      surahNameEnglish: 'Al-Fatihah',
      textArabic: 'ٱلرَّحْمَـٰنِ ٱلرَّحِيمِ',
      translation: 'The Entirely Merciful, the Especially Merciful,',
      imageUrl: 'https://everyayah.com/data/images_png/1_3.png',
      audioUrl: 'https://everyayah.com/data/Abdul_Basit_Murattal_64kbps/001003.mp3',
    ),
    const Ayah(
      id: 4,
      surahNumber: 1,
      ayahNumber: 4,
      surahNameArabic: 'الفاتحة',
      surahNameEnglish: 'Al-Fatihah',
      textArabic: 'مَـٰلِكِ يَوْمِ ٱلدِّينِ',
      translation: 'Sovereign of the Day of Recompense.',
      imageUrl: 'https://everyayah.com/data/images_png/1_4.png',
      audioUrl: 'https://everyayah.com/data/Abdul_Basit_Murattal_64kbps/001004.mp3',
    ),
    const Ayah(
      id: 5,
      surahNumber: 1,
      ayahNumber: 5,
      surahNameArabic: 'الفاتحة',
      surahNameEnglish: 'Al-Fatihah',
      textArabic: 'إِيَّاكَ نَعْبُدُ وَإِيَّاكَ نَسْتَعِينُ',
      translation: 'It is You we worship and You we ask for help.',
      imageUrl: 'https://everyayah.com/data/images_png/1_5.png',
      audioUrl: 'https://everyayah.com/data/Abdul_Basit_Murattal_64kbps/001005.mp3',
    ),
    const Ayah(
      id: 6,
      surahNumber: 1,
      ayahNumber: 6,
      surahNameArabic: 'الفاتحة',
      surahNameEnglish: 'Al-Fatihah',
      textArabic: 'ٱهْدِنَا ٱلصِّرَٰطَ ٱلْمُسْتَقِيمَ',
      translation: 'Guide us to the straight path -',
      imageUrl: 'https://everyayah.com/data/images_png/1_6.png',
      audioUrl: 'https://everyayah.com/data/Abdul_Basit_Murattal_64kbps/001006.mp3',
    ),
    const Ayah(
      id: 7,
      surahNumber: 1,
      ayahNumber: 7,
      surahNameArabic: 'الفاتحة',
      surahNameEnglish: 'Al-Fatihah',
      textArabic: 'صِرَٰطَ ٱلَّذِينَ أَنْعَمْتَ عَلَيْهِمْ غَيْرِ ٱلْمَغْضُوبِ عَلَيْهِمْ وَلَا ٱلضَّآلِّينَ',
      translation: 'The path of those upon whom You have bestowed favor, not of those who have evoked [Your] anger or of those who are astray.',
      imageUrl: 'https://everyayah.com/data/images_png/1_7.png',
      audioUrl: 'https://everyayah.com/data/Abdul_Basit_Murattal_64kbps/001007.mp3',
    ),
  ];

  List<Ayah> get memoryFallbackAyahs {
    _memoryFallback ??= List<Ayah>.from(initialAyahsSeed);
    return _memoryFallback!;
  }
}
