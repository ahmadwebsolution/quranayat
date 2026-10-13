class Ayah {
  final int id;
  final int surahNumber;
  final int ayahNumber;
  final String surahNameArabic;
  final String surahNameEnglish;
  final String textArabic;
  final String translation;
  final String imageUrl;
  final String audioUrl;
  final bool isFavorite;

  const Ayah({
    required this.id,
    required this.surahNumber,
    required this.ayahNumber,
    required this.surahNameArabic,
    required this.surahNameEnglish,
    required this.textArabic,
    required this.translation,
    required this.imageUrl,
    required this.audioUrl,
    this.isFavorite = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'surah_number': surahNumber,
      'ayah_number': ayahNumber,
      'surah_name_arabic': surahNameArabic,
      'surah_name_english': surahNameEnglish,
      'text_arabic': textArabic,
      'translation': translation,
      'image_url': imageUrl,
      'audio_url': audioUrl,
      'is_favorite': isFavorite ? 1 : 0,
    };
  }

  factory Ayah.fromMap(Map<String, dynamic> map) {
    return Ayah(
      id: map['id'] as int,
      surahNumber: map['surah_number'] as int,
      ayahNumber: map['ayah_number'] as int,
      surahNameArabic: (map['surah_name_arabic'] as String?) ?? '',
      surahNameEnglish: (map['surah_name_english'] as String?) ?? '',
      textArabic: (map['text_arabic'] as String?) ?? '',
      translation: (map['translation'] as String?) ?? '',
      imageUrl: (map['image_url'] as String?) ?? '',
      audioUrl: (map['audio_url'] as String?) ?? '',
      isFavorite: (map['is_favorite'] as int? ?? 0) == 1,
    );
  }

  Ayah copyWith({
    int? id,
    int? surahNumber,
    int? ayahNumber,
    String? surahNameArabic,
    String? surahNameEnglish,
    String? textArabic,
    String? translation,
    String? imageUrl,
    String? audioUrl,
    bool? isFavorite,
  }) {
    return Ayah(
      id: id ?? this.id,
      surahNumber: surahNumber ?? this.surahNumber,
      ayahNumber: ayahNumber ?? this.ayahNumber,
      surahNameArabic: surahNameArabic ?? this.surahNameArabic,
      surahNameEnglish: surahNameEnglish ?? this.surahNameEnglish,
      textArabic: textArabic ?? this.textArabic,
      translation: translation ?? this.translation,
      imageUrl: imageUrl ?? this.imageUrl,
      audioUrl: audioUrl ?? this.audioUrl,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}
