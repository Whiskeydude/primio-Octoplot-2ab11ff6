import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../models/game_models.dart';
import '../../services/game_service.dart';
import '../../services/sound_service.dart';

class SettingsProvider extends ChangeNotifier {
  final GameService _service;
  Difficulty _difficulty = Difficulty.mastermind;
  bool _muted = false;
  String? _error;
  String? _soundError;

  SettingsProvider({required GameService service}) : _service = service {
    SoundService.instance.error.addListener(_onSoundError);
  }

  Difficulty get difficulty => _difficulty;
  bool get muted => _muted;
  String? get error => _error;
  String? get soundError => _soundError;

  Future<void> load() async {
    try {
      _difficulty = await _service.loadDifficulty();
      _muted = await _service.loadMuted();
      SoundService.instance.setMuted(_muted);
      _error = null;
    } catch (e) {
      _error = 'Could not load settings: $e';
    }
    notifyListeners();
  }

  Future<void> setDifficulty(Difficulty value) async {
    _difficulty = value;
    _error = null;
    notifyListeners();
    try {
      await _service.saveDifficulty(value);
    } catch (e) {
      _error = 'Could not save difficulty: $e';
      notifyListeners();
    }
  }

  Future<void> toggleMuted() async {
    _muted = !_muted;
    _error = null;
    SoundService.instance.setMuted(_muted);
    notifyListeners();
    try {
      await _service.saveMuted(_muted);
    } catch (e) {
      _error = 'Could not save sound setting: $e';
      notifyListeners();
    }
  }

  /// Browsers allow sound only after a tap, so the menu calls this on taps.
  void startSound() => unawaited(SoundService.instance.start());

  void _onSoundError() {
    _soundError = SoundService.instance.error.value;
    notifyListeners();
  }

  @override
  void dispose() {
    SoundService.instance.error.removeListener(_onSoundError);
    super.dispose();
  }
}
