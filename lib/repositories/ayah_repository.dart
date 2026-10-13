import '../core/constants.dart';
import '../core/db/app_database.dart';
import '../models/ayah.dart';

class AyahRepository {
  final AppDatabase _dbProvider;

  AyahRepository({AppDatabase? dbProvider})
      : _dbProvider = dbProvider ?? AppDatabase.instance;

  Future<List<Ayah>> getAllAyahs() async {
    final db = await _dbProvider.database;
    if (db == null) {
      return _dbProvider.memoryFallbackAyahs;
    }

    try {
      final maps = await db.query(
        AppConstants.tableNameAyahs,
        orderBy: 'surah_number ASC, ayah_number ASC',
      );

      if (maps.isEmpty) {
        // Re-seed if empty
        for (final ayah in AppDatabase.initialAyahsSeed) {
          await db.insert(AppConstants.tableNameAyahs, ayah.toMap());
        }
        return AppDatabase.initialAyahsSeed;
      }

      // Automatically migrate any stale audio URLs from previous version
      if (maps.any((m) => (m['audio_url'] as String? ?? '').contains('QuranExplorer.Com'))) {
        for (final seed in AppDatabase.initialAyahsSeed) {
          await db.update(
            AppConstants.tableNameAyahs,
            {'audio_url': seed.audioUrl},
            where: 'id = ?',
            whereArgs: [seed.id],
          );
        }
        final refreshedMaps = await db.query(
          AppConstants.tableNameAyahs,
          orderBy: 'surah_number ASC, ayah_number ASC',
        );
        return refreshedMaps.map((map) => Ayah.fromMap(map)).toList();
      }

      return maps.map((map) => Ayah.fromMap(map)).toList();
    } catch (_) {
      return _dbProvider.memoryFallbackAyahs;
    }
  }

  Future<Ayah?> getAyahById(int id) async {
    final db = await _dbProvider.database;
    if (db == null) {
      final list = _dbProvider.memoryFallbackAyahs;
      return list.cast<Ayah?>().firstWhere((a) => a?.id == id, orElse: () => null);
    }

    try {
      final maps = await db.query(
        AppConstants.tableNameAyahs,
        where: 'id = ?',
        whereArgs: [id],
        limit: 1,
      );
      if (maps.isNotEmpty) {
        return Ayah.fromMap(maps.first);
      }
      return null;
    } catch (_) {
      final list = _dbProvider.memoryFallbackAyahs;
      return list.cast<Ayah?>().firstWhere((a) => a?.id == id, orElse: () => null);
    }
  }

  Future<void> toggleFavorite(int id, bool isFavorite) async {
    final db = await _dbProvider.database;
    if (db != null) {
      try {
        await db.update(
          AppConstants.tableNameAyahs,
          {'is_favorite': isFavorite ? 1 : 0},
          where: 'id = ?',
          whereArgs: [id],
        );
      } catch (_) {}
    }

    // Update in memory fallback as well
    final list = _dbProvider.memoryFallbackAyahs;
    final index = list.indexWhere((a) => a.id == id);
    if (index != -1) {
      list[index] = list[index].copyWith(isFavorite: isFavorite);
    }
  }
}
