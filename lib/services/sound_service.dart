import 'dart:async';
import 'dart:math';
import 'dart:typed_data';

import 'package:audio_session/audio_session.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/widgets.dart';
import 'package:flutter_soloud/flutter_soloud.dart';

import 'synth.dart';

/// The app's only owner of the SoLoud engine. Every sound goes through here.
class SoundService {
  SoundService._();
  static final SoundService instance = SoundService._();

  static const _initTimeout = Duration(seconds: 3);

  final SoLoud _soloud = SoLoud.instance;
  final Map<String, AudioSource> _sources = {};
  final Map<String, double> _loopVolumes = {};
  final Map<String, SoundHandle> _loops = {};
  final Map<String, int> _lastPlayedMs = {};
  final Stopwatch _clock = Stopwatch()..start();
  final Random _random = Random();

  /// True once the engine runs and the sounds are loaded.
  final ValueNotifier<bool> ready = ValueNotifier(false);

  /// Why sound is off; null when it works.
  final ValueNotifier<String?> error = ValueNotifier(null);

  Future<bool>? _starting;
  AppLifecycleListener? _lifecycle;
  StreamSubscription<AudioDeviceStartFailure>? _deviceFailures;
  bool _inBackground = false;
  bool _muted = false;
  bool _wakeOnTap = false;

  bool get muted => _muted;

  /// Starts the engine and loads every sound. Call it from the first tap.
  Future<bool> start() async {
    if (ready.value) {
      if (error.value != null) _recover();
      return true;
    }
    final starting = _starting ??= _start().whenComplete(() => _starting = null);
    try {
      return await starting.timeout(_initTimeout);
    } on TimeoutException {
      error.value ??= 'Sound is still starting.';
      return false;
    }
  }

  Future<bool> _start() async {
    try {
      await _configureSession();
      if (!_soloud.isInitialized) {
        try {
          await _soloud.init();
        } on SoLoudPlayerAlreadyInitializedException {
          await _soloud.deinitAsync();
          await _soloud.init();
        }
      }
      _soloud.setMaxActiveVoiceCount(32);
      _deviceFailures ??= _soloud.audioDeviceStartFailures.listen(
        (_) => error.value = 'Sound stopped: the speaker could not start.',
      );
      await _loadSounds();
      _lifecycle ??= AppLifecycleListener(
        onHide: () => _setInBackground(true),
        onShow: () => _setInBackground(false),
      );
      final state = WidgetsBinding.instance.lifecycleState;
      _inBackground = state == AppLifecycleState.hidden || state == AppLifecycleState.paused;
      error.value = null;
      ready.value = true;
      _loopVolumes.keys.toList().forEach(_startLoop);
      return true;
    } catch (e) {
      error.value = 'Sound could not start: $e';
      return false;
    }
  }

  Future<void> _configureSession() async {
    try {
      final session = await AudioSession.instance;
      await session.configure(const AudioSessionConfiguration(
        avAudioSessionCategory: AVAudioSessionCategory.ambient,
      ));
    } catch (_) {
      // Sound still plays with the system's default session.
    }
  }

  Future<void> _loadSounds() async {
    Future<void> load(String name, Uint8List bytes) async {
      _sources[name] = await _soloud.loadMem('$name.wav', bytes);
    }

    _sources.clear();
    await load('tap', Synth.tone(hz: 520, toHz: 700, ms: 70, decay: 40));
    await load('op_0', Synth.noise(ms: 260, decay: 12));
    await load('op_1', Synth.tone(hz: 330, toHz: 180, ms: 260, decay: 10, harmonics: const [1, 0.4]));
    await load('op_2', Synth.tone(hz: 140, toHz: 45, ms: 520, decay: 6, harmonics: const [1, 0.6, 0.3]));
    await load('seize', Synth.chime());
    await load('good', Synth.tone(hz: 660, toHz: 990, ms: 280, decay: 9, harmonics: const [1, 0.3]));
    await load('bad', Synth.tone(hz: 260, toHz: 110, ms: 420, decay: 7, harmonics: const [1, 0.7, 0.4]));
    await load(
      'alarm',
      Synth.melody(
        const [(440.0, 160), (0.0, 60), (440.0, 160), (0.0, 60), (330.0, 300)],
        decay: 5,
        harmonics: const [1, 0.6, 0.3],
      ),
    );
    await load(
      'win',
      Synth.melody([
        (Synth.note(60), 160),
        (Synth.note(64), 160),
        (Synth.note(67), 160),
        (Synth.note(72), 520),
      ], decay: 4),
    );
    await load('lose', Synth.tone(hz: 300, toHz: 50, ms: 1300, decay: 2.5, harmonics: const [1, 0.6]));
    await load('drone', Synth.noiseLoop(smoothing: 0.02, seed: 3));
    await load(
      'heart',
      Synth.melody(
        const [(70.0, 140), (0.0, 110), (70.0, 140), (0.0, 810)],
        decay: 14,
        harmonics: const [1, 0.8, 0.5],
      ),
    );
  }

  /// Plays a short sound. Rapid calls overlap; each one is a new voice.
  void play(String name, {double volume = 0.5, double pitchJitter = 0.06}) {
    final source = _sources[name];
    if (_muted || _inBackground || !ready.value || source == null) return;
    if (_wakeOnTap) {
      _wakeOnTap = false;
      unawaited(_startDevice());
    }
    final now = _clock.elapsedMilliseconds;
    if (now - (_lastPlayedMs[name] ?? -1000) < 40) return;
    _lastPlayedMs[name] = now;
    final speed = 1 + (_random.nextDouble() * 2 - 1) * pitchJitter;
    _guard(() => _soloud.play(source, volume: volume, scale: speed));
  }

  /// Starts a looping sound, now or once sound is ready. On a loop that is
  /// already wanted, it changes the volume.
  void startLoop(String name, {double volume = 0.4}) {
    final wanted = _loopVolumes.containsKey(name);
    _loopVolumes[name] = volume;
    wanted ? setLoopVolume(name, volume) : _startLoop(name);
  }

  void _startLoop(String name) {
    final source = _sources[name];
    final volume = _loopVolumes[name];
    if (!ready.value || source == null || volume == null) return;
    _guard(() {
      final current = _loops[name];
      if (current != null && _soloud.getIsValidVoiceHandle(current)) return;
      final handle = _soloud.play(source, looping: true, volume: 0, paused: _inBackground);
      _soloud.setProtectVoice(handle, true);
      _soloud.fadeVolume(handle, _muted ? 0 : volume, const Duration(seconds: 1));
      _loops[name] = handle;
    });
  }

  void setLoopVolume(String name, double volume) {
    if (!_loopVolumes.containsKey(name)) return;
    _loopVolumes[name] = volume;
    final handle = _loops[name];
    if (handle == null || _muted || !ready.value) return;
    _guard(() => _soloud.fadeVolume(handle, volume, const Duration(milliseconds: 300)));
  }

  void stopLoop(String name, {Duration fade = const Duration(milliseconds: 800)}) {
    _loopVolumes.remove(name);
    final handle = _loops.remove(name);
    if (handle == null || !ready.value) return;
    _guard(() {
      if (_inBackground) {
        unawaited(_soloud.stop(handle));
      } else {
        _soloud.fadeVolume(handle, 0, fade);
        _soloud.scheduleStop(handle, fade);
      }
    });
  }

  /// Mutes effects and loops.
  void setMuted(bool muted) {
    _muted = muted;
    if (!ready.value) return;
    _loops.forEach((name, handle) {
      final volume = muted ? 0.0 : _loopVolumes[name] ?? 0.0;
      _guard(() => _soloud.fadeVolume(handle, volume, const Duration(milliseconds: 300)));
    });
  }

  void _setInBackground(bool background) {
    _inBackground = background;
    if (!ready.value) return;
    for (final handle in _loops.values) {
      _guard(() {
        if (_soloud.getIsValidVoiceHandle(handle)) _soloud.setPause(handle, background);
      });
    }
    if (!background) {
      _wakeOnTap = kIsWeb;
      _recover();
    }
  }

  void _recover() {
    error.value = null;
    unawaited(_startDevice());
    _loopVolumes.keys.toList().forEach(_startLoop);
  }

  Future<void> _startDevice() async {
    try {
      if (kIsWeb) await _soloud.stopAudioDevice(force: true);
      await _soloud.startAudioDevice();
    } catch (e) {
      error.value = 'Sound stopped: $e';
    }
  }

  void _guard(void Function() action) {
    try {
      action();
    } catch (e) {
      if (e is SoLoudNotInitializedException ||
          e is SoLoudSoundHashNotFoundCppException ||
          e is SoLoudSoundHashNotFoundDartException) {
        ready.value = false;
      }
      error.value = 'Sound stopped: $e';
    }
  }
}
