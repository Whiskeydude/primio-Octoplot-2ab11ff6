import 'dart:async';

import 'package:flutter/services.dart';

import '../models/game_models.dart';
import 'sound_service.dart';

/// Turns game moments into sound and vibration. Both follow the mute switch.
abstract final class GameFeedback {
  static const _alarmLevel = 75;
  static const _heartLevel = 60;

  static SoundService get _sound => SoundService.instance;

  static void _haptic(Future<void> Function() impact) {
    if (!_sound.muted) unawaited(impact());
  }

  static void select() {
    _sound.play('tap', volume: 0.3);
    _haptic(HapticFeedback.selectionClick);
  }

  static void operation(int index) {
    _sound.play('op_${index.clamp(0, 2)}', volume: index == 0 ? 0.2 : 0.45);
    _haptic(index >= 2 ? HapticFeedback.mediumImpact : HapticFeedback.lightImpact);
  }

  static void lieLow() {
    _sound.play('tap', volume: 0.25, pitchJitter: 0.2);
    _haptic(HapticFeedback.lightImpact);
  }

  /// Reacts to what changed between two states after a turn.
  static void afterTurn(GameState prev, GameState next) {
    if (next.status == GameStatus.won) {
      stopAmbience();
      _sound.play('win', volume: 0.5);
      _haptic(HapticFeedback.heavyImpact);
      return;
    }
    if (next.status == GameStatus.lost) {
      stopAmbience();
      _sound.play('lose', volume: 0.55);
      _haptic(HapticFeedback.heavyImpact);
      return;
    }
    if (next.seizedCount > prev.seizedCount) {
      _sound.play('seize', volume: 0.45);
      _haptic(HapticFeedback.mediumImpact);
    }
    final event = next.lastEvent;
    if (event != null) {
      _sound.play(event.isGood ? 'good' : 'bad', volume: 0.45);
      if (!event.isGood) _haptic(HapticFeedback.mediumImpact);
    }
    if (prev.suspicion < _alarmLevel && next.suspicion >= _alarmLevel) {
      _sound.play('alarm', volume: 0.5);
      _haptic(HapticFeedback.heavyImpact);
    }
    updateAmbience(next.suspicion);
  }

  /// The abyss hum grows with suspicion; a heartbeat joins when it gets risky.
  static void updateAmbience(int suspicion) {
    _sound.startLoop('drone', volume: 0.1 + suspicion * 0.003);
    if (suspicion >= _heartLevel) {
      _sound.startLoop('heart', volume: 0.15 + (suspicion - _heartLevel) * 0.01);
    } else {
      _sound.stopLoop('heart');
    }
  }

  static void stopAmbience() {
    _sound.stopLoop('drone');
    _sound.stopLoop('heart');
  }
}
