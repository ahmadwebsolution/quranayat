import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';

class AudioService {
  final AudioPlayer _player = AudioPlayer();
  String? _currentUrl;

  Stream<PlayerState> get playerStateStream => _player.playerStateStream;
  Stream<Duration> get positionStream => _player.positionStream;
  Stream<Duration?> get durationStream => _player.durationStream;

  bool get isPlaying => _player.playing;
  String? get currentUrl => _currentUrl;
  Duration get currentPosition => _player.position;
  Duration? get duration => _player.duration;

  Future<void> play(String url) async {
    try {
      if (_currentUrl != url) {
        _currentUrl = url;
        await _player.setUrl(url);
      } else if (_player.processingState == ProcessingState.completed) {
        await _player.seek(Duration.zero);
      }
      await _player.play();
    } catch (e) {
      debugPrint('Error playing audio from $url: $e');
    }
  }

  Future<void> pause() async {
    try {
      await _player.pause();
    } catch (e) {
      debugPrint('Error pausing audio: $e');
    }
  }

  Future<void> resume() async {
    try {
      await _player.play();
    } catch (e) {
      debugPrint('Error resuming audio: $e');
    }
  }

  Future<void> stop() async {
    try {
      await _player.stop();
    } catch (e) {
      debugPrint('Error stopping audio: $e');
    }
  }

  Future<void> seek(Duration position) async {
    try {
      await _player.seek(position);
    } catch (e) {
      debugPrint('Error seeking audio: $e');
    }
  }

  void dispose() {
    _player.dispose();
  }
}
