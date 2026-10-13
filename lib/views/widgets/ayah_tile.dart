import 'package:flutter/material.dart';
import '../../core/constants.dart';
import '../../models/ayah.dart';

class AyahTile extends StatelessWidget {
  final Ayah ayah;
  final bool isSelected;
  final bool isPlaying;
  final VoidCallback onPlayTap;
  final VoidCallback onFavoriteTap;

  const AyahTile({
    super.key,
    required this.ayah,
    required this.isSelected,
    required this.isPlaying,
    required this.onPlayTap,
    required this.onFavoriteTap,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeOutCubic,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isSelected
            ? const Color(0xFF141F33).withValues(alpha: 0.9)
            : const Color(0xFF0F1726).withValues(alpha: 0.75),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isSelected
              ? AppConstants.goldPrimary.withValues(alpha: 0.7)
              : Colors.white.withValues(alpha: 0.08),
          width: isSelected ? 1.5 : 1.0,
        ),
        boxShadow: [
          if (isSelected)
            BoxShadow(
              color: AppConstants.goldPrimary.withValues(alpha: 0.22),
              blurRadius: 20,
              spreadRadius: 1,
              offset: const Offset(0, 4),
            )
          else
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.35),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header: Surah & Ayah Badges + Favorite Button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Levitating Ayat number badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  gradient: isSelected
                      ? AppConstants.goldGradient
                      : LinearGradient(
                          colors: [
                            Colors.white.withValues(alpha: 0.12),
                            Colors.white.withValues(alpha: 0.05),
                          ],
                        ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: AppConstants.goldPrimary.withValues(alpha: 0.4),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          )
                        ]
                      : null,
                ),
                child: Text(
                  'Ayah ${ayah.surahNumber}:${ayah.ayahNumber}',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: isSelected ? Colors.black87 : AppConstants.goldLight,
                    letterSpacing: 0.5,
                  ),
                ),
              ),

              Row(
                children: [
                  if (isSelected && isPlaying)
                    Container(
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppConstants.goldPrimary.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: AppConstants.goldPrimary.withValues(alpha: 0.4),
                        ),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.graphic_eq_rounded,
                              size: 14, color: AppConstants.goldPrimary),
                          SizedBox(width: 4),
                          Text(
                            'RECITING',
                            style: TextStyle(
                              color: AppConstants.goldPrimary,
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                  IconButton(
                    iconSize: 20,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    icon: Icon(
                      ayah.isFavorite
                          ? Icons.bookmark_rounded
                          : Icons.bookmark_border_rounded,
                      color: ayah.isFavorite
                          ? AppConstants.goldPrimary
                          : AppConstants.textMuted,
                    ),
                    onPressed: onFavoriteTap,
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Glowing Ayah Image from EveryAyah PNG
          if (ayah.imageUrl.isNotEmpty)
            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  color: isSelected
                      ? AppConstants.goldPrimary.withValues(alpha: 0.06)
                      : Colors.transparent,
                ),
                child: ColorFiltered(
                  // Inverts and tones black-on-white PNG to glowing gold/white on dark background
                  colorFilter: const ColorFilter.matrix([
                    -1, 0, 0, 0, 255, // R
                    -1, 0, 0, 0, 230, // G
                    -1, 0, 0, 0, 180, // B
                    0, 0, 0, 1, 0,    // A
                  ]),
                  child: Image.network(
                    ayah.imageUrl,
                    height: 52,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Text(
                        ayah.textArabic,
                        textAlign: TextAlign.center,
                        textDirection: TextDirection.rtl,
                        style: TextStyle(
                          fontSize: 22,
                          color: isSelected
                              ? AppConstants.goldLight
                              : AppConstants.textWhite,
                          fontWeight: FontWeight.w600,
                          height: 1.8,
                        ),
                      );
                    },
                  ),
                ),
              ),
            )
          else
            Text(
              ayah.textArabic,
              textAlign: TextAlign.center,
              textDirection: TextDirection.rtl,
              style: TextStyle(
                fontSize: 22,
                color: isSelected ? AppConstants.goldLight : AppConstants.textWhite,
                fontWeight: FontWeight.w600,
                height: 1.8,
              ),
            ),

          const SizedBox(height: 12),

          // Translation text
          Text(
            ayah.translation,
            style: TextStyle(
              fontSize: 13,
              height: 1.5,
              color: isSelected
                  ? AppConstants.textWhite.withValues(alpha: 0.9)
                  : AppConstants.textMuted,
            ),
          ),

          const SizedBox(height: 14),

          // Floating Levitation Action Bar
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: onPlayTap,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    gradient: isPlaying && isSelected
                        ? AppConstants.goldGradient
                        : LinearGradient(
                            colors: [
                              AppConstants.goldPrimary.withValues(alpha: 0.2),
                              AppConstants.goldPrimary.withValues(alpha: 0.08),
                            ],
                          ),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: AppConstants.goldPrimary.withValues(alpha: 0.5),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppConstants.goldPrimary.withValues(
                            alpha: isPlaying && isSelected ? 0.35 : 0.1),
                        blurRadius: 12,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isPlaying && isSelected
                            ? Icons.pause_rounded
                            : Icons.play_arrow_rounded,
                        size: 18,
                        color: isPlaying && isSelected
                            ? Colors.black
                            : AppConstants.goldPrimary,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        isPlaying && isSelected ? 'Pause' : 'Listen',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: isPlaying && isSelected
                              ? Colors.black
                              : AppConstants.goldPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
