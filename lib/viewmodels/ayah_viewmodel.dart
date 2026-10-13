import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';
import '../models/ayah.dart';
import '../repositories/ayah_repository.dart';
import '../services/audio_service.dart';

class AyahViewModel extends ChangeNotifier {
  final AyahRepository _repository;
  final AudioService _audioService;

  List<Ayah> _ayahs = [];
  Ayah? _currentAyah;
  bool _isLoading = true;
  bool _isPlaying = false;
  bool _isBuffering = false;
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;

  StreamSubscription<PlayerState>? _playerStateSubscription;
  StreamSubscription<Duration>? _positionSubscription;
  StreamSubscription<Duration?>? _durationSubscription;

  AyahViewModel({
    AyahRepository? repository,
    AudioService? audioService,
  })  : _repository = repository ?? AyahRepository(),
        _audioService = audioService ?? AudioService() {
    _initAudioListeners();
    loadAyahs();
  }

  List<Ayah> get ayahs => _ayahs;
  Ayah? get currentAyah => _currentAyah;
  bool get isLoading => _isLoading;
  bool get isPlaying => _isPlaying;
  bool get isBuffering => _isBuffering;
  Duration get position => _position;
  Duration get duration => _duration;
  AudioService get audioService => _audioService;

  void _initAudioListeners() {
    _playerStateSubscription = _audioService.playerStateStream.listen((state) {
      _isPlaying = state.playing;
      _isBuffering = state.processingState == ProcessingState.buffering;

      if (state.processingState == ProcessingState.completed) {
        _isPlaying = false;
        _position = Duration.zero;
        playNext(); // Auto-advance in audiobook mode
      }
      notifyListeners();
    });

    _positionSubscription = _audioService.positionStream.listen((pos) {
      _position = pos;
      notifyListeners();
    });

    _durationSubscription = _audioService.durationStream.listen((dur) {
      _duration = dur ?? Duration.zero;
      notifyListeners();
    });
  }

  Future<void> loadAyahs() async {
    _isLoading = true;
    notifyListeners();

    _ayahs = await _repository.getAllAyahs();
    if (_ayahs.isNotEmpty && _currentAyah == null) {
      _currentAyah = _ayahs.first;
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> selectAyah(Ayah ayah, {bool autoPlay = true}) async {
    _currentAyah = ayah;
    _position = Duration.zero;
    notifyListeners();
    if (autoPlay) {
      await _audioService.play(ayah.audioUrl);
    }
  }

  Future<void> togglePlayPause() async {
    if (_currentAyah == null) {
      if (_ayahs.isNotEmpty) {
        await selectAyah(_ayahs.first, autoPlay: true);
      }
      return;
    }

    if (_isPlaying) {
      await _audioService.pause();
    } else {
      await _audioService.play(_currentAyah!.audioUrl);
    }
  }

  Future<void> playNext() async {
    if (_ayahs.isEmpty || _currentAyah == null) return;
    final currentIndex = _ayahs.indexWhere((a) => a.id == _currentAyah!.id);
    if (currentIndex != -1 && currentIndex < _ayahs.length - 1) {
      await selectAyah(_ayahs[currentIndex + 1], autoPlay: true);
    } else if (_ayahs.isNotEmpty) {
      // Loop back to start
      await selectAyah(_ayahs.first, autoPlay: true);
    }
  }

  Future<void> playPrevious() async {
    if (_ayahs.isEmpty || _currentAyah == null) return;
    final currentIndex = _ayahs.indexWhere((a) => a.id == _currentAyah!.id);
    if (currentIndex > 0) {
      await selectAyah(_ayahs[currentIndex - 1], autoPlay: true);
    }
  }

  Future<void> seek(Duration position) async {
    await _audioService.seek(position);
  }

  Future<void> toggleFavorite(Ayah ayah) async {
    final newFav = !ayah.isFavorite;
    await _repository.toggleFavorite(ayah.id, newFav);
    final index = _ayahs.indexWhere((a) => a.id == ayah.id);
    if (index != -1) {
      _ayahs[index] = _ayahs[index].copyWith(isFavorite: newFav);
    }
    if (_currentAyah?.id == ayah.id) {
      _currentAyah = _currentAyah!.copyWith(isFavorite: newFav);
    }
    notifyListeners();
  }

  @override
  void dispose() {
    _playerStateSubscription?.cancel();
    _positionSubscription?.cancel();
    _durationSubscription?.cancel();
    _audioService.dispose();
    super.dispose();
  }
}
