import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../core/constants.dart';
import '../models/ayah.dart';
import '../viewmodels/ayah_viewmodel.dart';
import 'widgets/ayah_tile.dart';

class AyahListScreen extends StatefulWidget {
  const AyahListScreen({super.key});

  @override
  State<AyahListScreen> createState() => _AyahListScreenState();
}

class _AyahListScreenState extends State<AyahListScreen>
    with TickerProviderStateMixin {
  late final AyahViewModel _viewModel;
  late final AnimationController _levitationController;
  late final AnimationController _pulseController;
  late final AnimationController _particleController;

  @override
  void initState() {
    super.initState();
    _viewModel = AyahViewModel();


    _levitationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3200),
    )..repeat(reverse: true);

    // Glowing pulse animation for active play button
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);

    // Particle drift animation
    _particleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();
  }

  @override
  void dispose() {
    _levitationController.dispose();
    _pulseController.dispose();
    _particleController.dispose();
    _viewModel.dispose();
    super.dispose();
  }

  String _formatDuration(Duration d) {
    final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _viewModel,
      builder: (context, _) {
        final currentAyah = _viewModel.currentAyah;

        return Scaffold(
          backgroundColor: AppConstants.bgDark,
          body: Stack(
            children: [
              // 1. Antigravity Ambient Background & Golden Dust Particles
              Positioned.fill(
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: AppConstants.cosmicGradient,
                  ),
                ),
              ),

              // Glowing Ambient Light Orbs
              Positioned(
                top: -80,
                right: -40,
                child: Container(
                  width: 260,
                  height: 260,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        AppConstants.goldPrimary.withValues(alpha: 0.18),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 240,
                left: -70,
                child: Container(
                  width: 220,
                  height: 220,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        AppConstants.glowCyan.withValues(alpha: 0.08),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),

              // Custom Animated Floating Particles
              Positioned.fill(
                child: AnimatedBuilder(
                  animation: _particleController,
                  builder: (context, child) {
                    return CustomPaint(
                      painter: CosmicDustPainter(
                        progress: _particleController.value,
                      ),
                    );
                  },
                ),
              ),

              // Main Content
              SafeArea(
                child: _viewModel.isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: AppConstants.goldPrimary,
                        ),
                      )
                    : CustomScrollView(
                        physics: const BouncingScrollPhysics(),
                        slivers: [
                          // App Bar with Surreal Branding
                          SliverToBoxAdapter(
                            child: _buildHeader(),
                          ),

                          // Hero Stage: Floating Ayah Card & Levitating Controls
                          if (currentAyah != null)
                            SliverToBoxAdapter(
                              child: _buildLevitatingHeroStage(currentAyah),
                            ),

                          // Section Title
                          SliverToBoxAdapter(
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(20, 24, 20, 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        width: 4,
                                        height: 18,
                                        decoration: BoxDecoration(
                                          color: AppConstants.goldPrimary,
                                          borderRadius:
                                              BorderRadius.circular(2),
                                          boxShadow: [
                                            BoxShadow(
                                              color: AppConstants.goldPrimary
                                                  .withValues(alpha: 0.6),
                                              blurRadius: 8,
                                            )
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      const Text(
                                        'Surah Al-Fatihah • Verses',
                                        style: TextStyle(
                                          color: AppConstants.textWhite,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withValues(alpha: 0.06),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: Colors.white.withValues(alpha: 0.08),
                                      ),
                                    ),
                                    child: Text(
                                      '${_viewModel.ayahs.length} Ayats',
                                      style: const TextStyle(
                                        color: AppConstants.goldLight,
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          // List of All Ayahs
                          SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (context, index) {
                                final ayah = _viewModel.ayahs[index];
                                final isSelected =
                                    _viewModel.currentAyah?.id == ayah.id;
                                final isPlaying =
                                    isSelected && _viewModel.isPlaying;

                                return AyahTile(
                                  ayah: ayah,
                                  isSelected: isSelected,
                                  isPlaying: isPlaying,
                                  onPlayTap: () {
                                    if (isSelected) {
                                      _viewModel.togglePlayPause();
                                    } else {
                                      _viewModel.selectAyah(ayah);
                                    }
                                  },
                                  onFavoriteTap: () {
                                    _viewModel.toggleFavorite(ayah);
                                  },
                                );
                              },
                              childCount: _viewModel.ayahs.length,
                            ),
                          ),

                          const SliverToBoxAdapter(
                            child: SizedBox(height: 40),
                          ),
                        ],
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      gradient: AppConstants.goldGradient,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text(
                      'إِنَّ مَعَ الْعُسْرِ يُسْرًا AUDIO',
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w900,
                        color: Colors.black,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.auto_awesome,
                      size: 14, color: AppConstants.goldPrimary),
                ],
              ),
              const SizedBox(height: 6),
              const Text(
                'سُورَةُ ٱلْفَاتِحَةِ',
                style: TextStyle(
                  color: AppConstants.goldLight,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.05),
              shape: BoxShape.circle,
              border: Border.all(
                color: AppConstants.goldPrimary.withValues(alpha: 0.3),
              ),
              boxShadow: [
                BoxShadow(
                  color: AppConstants.goldPrimary.withValues(alpha: 0.15),
                  blurRadius: 12,
                ),
              ],
            ),
            child: IconButton(
              icon: const Icon(Icons.headphones_rounded,
                  color: AppConstants.goldPrimary),
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLevitatingHeroStage(Ayah currentAyah) {
    return AnimatedBuilder(
      animation: Listenable.merge([_levitationController, _pulseController]),
      builder: (context, _) {
        final floatOffset = math.sin(_levitationController.value * math.pi * 2) * 8.0;
        final pulseValue = _pulseController.value;

        return Transform.translate(
          offset: Offset(0, floatOffset),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(28),
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF16233B).withValues(alpha: 0.85),
                  const Color(0xFF0C1424).withValues(alpha: 0.95),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              border: Border.all(
                color: AppConstants.goldPrimary.withValues(alpha: 0.45 + (pulseValue * 0.25)),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppConstants.goldPrimary.withValues(alpha: 0.18 + (pulseValue * 0.15)),
                  blurRadius: 28,
                  spreadRadius: 2,
                  offset: const Offset(0, 8),
                ),
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.6),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(28),
              child: Stack(
                children: [
                  // Luminous golden aura overlay
                  Positioned(
                    top: -50,
                    right: 20,
                    child: Container(
                      width: 180,
                      height: 180,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            AppConstants.goldPrimary.withValues(alpha: 0.18),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(22),
                    child: Column(
                      children: [
                        // Surah status bar
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.08),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: AppConstants.goldPrimary.withValues(alpha: 0.3),
                                ),
                              ),
                              child: Text(
                                '${currentAyah.surahNameEnglish} • Ayah ${currentAyah.ayahNumber}',
                                style: const TextStyle(
                                  color: AppConstants.goldLight,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                if (_viewModel.isBuffering)
                                  const Padding(
                                    padding: EdgeInsets.only(right: 8.0),
                                    child: SizedBox(
                                      width: 14,
                                      height: 14,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: AppConstants.goldPrimary,
                                      ),
                                    ),
                                  ),
                                Icon(
                                  _viewModel.isPlaying
                                      ? Icons.graphic_eq_rounded
                                      : Icons.surround_sound_rounded,
                                  color: AppConstants.goldPrimary,
                                  size: 20,
                                ),
                              ],
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        // Glowing Ayah PNG Representation
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: AppConstants.goldPrimary.withValues(alpha: 0.2),
                            ),
                          ),
                          child: Column(
                            children: [
                              ColorFiltered(
                                colorFilter: const ColorFilter.matrix([
                                  -1, 0, 0, 0, 255, // Invert R
                                  -1, 0, 0, 0, 230, // Invert G with gold tone
                                  -1, 0, 0, 0, 160, // Invert B with warm tone
                                  0, 0, 0, 1, 0,
                                ]),
                                child: Image.network(
                                  currentAyah.imageUrl,
                                  height: 64,
                                  fit: BoxFit.contain,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Text(
                                      currentAyah.textArabic,
                                      textAlign: TextAlign.center,
                                      textDirection: TextDirection.rtl,
                                      style: const TextStyle(
                                        fontSize: 26,
                                        color: AppConstants.goldLight,
                                        fontWeight: FontWeight.bold,
                                        height: 1.8,
                                      ),
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                currentAyah.textArabic,
                                textAlign: TextAlign.center,
                                textDirection: TextDirection.rtl,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: AppConstants.goldLight.withValues(alpha: 0.85),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 16),

                        // English Translation
                        Text(
                          currentAyah.translation,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppConstants.textWhite.withValues(alpha: 0.9),
                            fontSize: 14,
                            height: 1.5,
                            fontStyle: FontStyle.italic,
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Audio Seek Bar
                        _buildProgressBar(),

                        const SizedBox(height: 14),

                        // Levitating Play Controls Deck
                        _buildLevitatingControls(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildProgressBar() {
    final pos = _viewModel.position;
    final total = _viewModel.duration;
    final totalMillis = total.inMilliseconds > 0 ? total.inMilliseconds : 1;
    final posMillis = pos.inMilliseconds.clamp(0, totalMillis);
    final rawRatio = totalMillis > 0 ? (posMillis / totalMillis) : 0.0;
    final progress = (rawRatio.isFinite ? rawRatio : 0.0).clamp(0.0, 1.0);

    return Column(
      children: [
        SliderTheme(
          data: SliderThemeData(
            trackHeight: 3.5,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
            overlayShape: const RoundSliderOverlayShape(overlayRadius: 14),
            activeTrackColor: AppConstants.goldPrimary,
            inactiveTrackColor: Colors.white.withValues(alpha: 0.12),
            thumbColor: AppConstants.goldLight,
            overlayColor: AppConstants.goldPrimary.withValues(alpha: 0.2),
          ),
          child: Slider(
            value: progress,
            onChanged: (val) {
              final newMs = (val * totalMillis).toInt();
              _viewModel.seek(Duration(milliseconds: newMs));
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _formatDuration(pos),
                style: TextStyle(
                  color: AppConstants.textMuted.withValues(alpha: 0.9),
                  fontSize: 11,
                  fontFamily: 'monospace',
                ),
              ),
              Text(
                _formatDuration(total),
                style: TextStyle(
                  color: AppConstants.textMuted.withValues(alpha: 0.9),
                  fontSize: 11,
                  fontFamily: 'monospace',
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLevitatingControls() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // Previous Ayah Button
        _buildSatelliteControl(
          icon: Icons.skip_previous_rounded,
          tooltip: 'Previous Ayah',
          onTap: () => _viewModel.playPrevious(),
        ),

        // Rewind 5s
        _buildSatelliteControl(
          icon: Icons.replay_5_rounded,
          tooltip: 'Rewind 5s',
          onTap: () {
            final newPos = _viewModel.position - const Duration(seconds: 5);
            _viewModel.seek(newPos < Duration.zero ? Duration.zero : newPos);
          },
        ),

        // Levitating Central Play/Pause Orb
        GestureDetector(
          onTap: () => _viewModel.togglePlayPause(),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            width: 68,
            height: 68,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: AppConstants.goldGradient,
              boxShadow: [
                BoxShadow(
                  color: AppConstants.goldPrimary.withValues(
                      alpha: _viewModel.isPlaying ? 0.6 : 0.3),
                  blurRadius: _viewModel.isPlaying ? 26 : 14,
                  spreadRadius: _viewModel.isPlaying ? 3 : 0,
                ),
              ],
            ),
            child: Center(
              child: Icon(
                _viewModel.isPlaying
                    ? Icons.pause_rounded
                    : Icons.play_arrow_rounded,
                size: 38,
                color: Colors.black87,
              ),
            ),
          ),
        ),

        // Forward 5s
        _buildSatelliteControl(
          icon: Icons.forward_5_rounded,
          tooltip: 'Forward 5s',
          onTap: () {
            final newPos = _viewModel.position + const Duration(seconds: 5);
            _viewModel.seek(newPos);
          },
        ),

        // Next Ayah Button
        _buildSatelliteControl(
          icon: Icons.skip_next_rounded,
          tooltip: 'Next Ayah',
          onTap: () => _viewModel.playNext(),
        ),
      ],
    );
  }

  Widget _buildSatelliteControl({
    required IconData icon,
    required String tooltip,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.06),
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.1),
        ),
      ),
      child: IconButton(
        iconSize: 22,
        tooltip: tooltip,
        icon: Icon(icon, color: AppConstants.goldLight),
        onPressed: onTap,
      ),
    );
  }
}

// Custom Painter for Floating Cosmic Stardust / Antigravity Particles
class CosmicDustPainter extends CustomPainter {
  final double progress;

  CosmicDustPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty || size.width <= 0 || size.height <= 0) return;

    final paint = Paint()..style = PaintingStyle.fill;

    const particleCount = 42;
    for (int i = 0; i < particleCount; i++) {
      final seed = i * 137.5;
      final xOffset = (seed % size.width);

      // Antigravity drift upwards with cyclic loop
      final rawY = ((seed * 3) - (progress * size.height * 0.8)) % size.height;
      final yOffset = rawY < 0 ? rawY + size.height : rawY;

      final radius = ((i % 4) + 1) * 0.8;
      final opacity = (((math.sin(progress * math.pi * 2 + i) + 1) / 2) * 0.45 + 0.1)
          .clamp(0.0, 0.7);

      paint.color = (i % 3 == 0)
          ? AppConstants.goldPrimary.withValues(alpha: opacity)
          : (i % 3 == 1)
              ? AppConstants.goldLight.withValues(alpha: opacity * 0.8)
              : AppConstants.glowCyan.withValues(alpha: opacity * 0.5);

      canvas.drawCircle(Offset(xOffset, yOffset), radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CosmicDustPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
