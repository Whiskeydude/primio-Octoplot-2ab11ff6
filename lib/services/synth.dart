import 'dart:math';
import 'dart:typed_data';

/// Sounds made in code, as WAV bytes for `SoLoud.instance.loadMem`.
abstract final class Synth {
  static const _rate = 44100;

  /// A short noise burst, for hits and whooshes.
  static Uint8List noise({int ms = 120, double decay = 30}) {
    final random = Random(7);
    final frames = _rate * ms ~/ 1000;
    return _wav([
      for (var i = 0; i < frames; i++)
        (random.nextDouble() * 2 - 1) * exp(-decay * i / _rate) * _release(i, frames),
    ]);
  }

  /// A bell-like chime for success.
  static Uint8List chime() => tone(hz: 880, ms: 900, decay: 5, harmonics: const [1, 0.5, 0.25, 0.12]);

  /// The frequency of a MIDI note number: 60 is middle C, 69 is A 440 Hz.
  static double note(int midi) => 440 * pow(2, (midi - 69) / 12).toDouble();

  /// A tone that can glide from [hz] to [toHz] and fades out with [decay].
  static Uint8List tone({
    required double hz,
    double? toHz,
    int ms = 150,
    double decay = 25,
    List<double> harmonics = const [1],
  }) =>
      _wav(_tone(hz, toHz ?? hz, ms, decay, harmonics));

  /// A tune: (frequency in Hz, or 0 for a rest; length in ms) per note.
  static Uint8List melody(
    List<(double, int)> notes, {
    double decay = 6,
    List<double> harmonics = const [1, 0.3, 0.1],
  }) =>
      _wav([
        for (final (hz, ms) in notes)
          ...(hz > 0 ? _tone(hz, hz, ms, decay, harmonics) : List.filled(_rate * ms ~/ 1000, 0.0)),
      ]);

  /// A seamless noise bed for loops. Lower [smoothing] is a deeper rumble.
  static Uint8List noiseLoop({int seconds = 8, double smoothing = 0.1, int seed = 1}) {
    final random = Random(seed);
    final length = seconds * _rate;
    final fade = _rate ~/ 2;
    final raw = List<double>.filled(length + fade, 0);
    var y = 0.0;
    for (var i = 0; i < raw.length; i++) {
      y += smoothing * ((random.nextDouble() * 2 - 1) - y);
      raw[i] = y;
    }
    final out = raw.sublist(0, length);
    for (var i = 0; i < fade; i++) {
      final w = i / fade;
      out[i] = out[i] * sqrt(w) + raw[length + i] * sqrt(1 - w);
    }
    final peak = out.fold<double>(0, (m, v) => max(m, v.abs()));
    return _wav([for (final v in out) v / peak]);
  }

  static List<double> _tone(double hz, double toHz, int ms, double decay, List<double> harmonics) {
    final frames = _rate * ms ~/ 1000;
    final norm = harmonics.fold<double>(0, (sum, level) => sum + level);
    final out = List<double>.filled(frames, 0);
    var phase = 0.0;
    for (var i = 0; i < frames; i++) {
      final t = i / _rate;
      phase += 2 * pi * hz * pow(toHz / hz, i / frames) / _rate;
      var value = 0.0;
      for (var h = 0; h < harmonics.length; h++) {
        value += harmonics[h] * sin(phase * (h + 1));
      }
      final attack = min(1.0, t * 500);
      out[i] = value / norm * attack * exp(-decay * t) * _release(i, frames);
    }
    return out;
  }

  static double _release(int i, int frames) => min(1.0, (frames - i) / (_rate * 0.005));

  static Uint8List _wav(List<double> samples) {
    final bytes = ByteData(44 + samples.length * 2);
    void text(int offset, String s) {
      for (var i = 0; i < s.length; i++) {
        bytes.setUint8(offset + i, s.codeUnitAt(i));
      }
    }

    text(0, 'RIFF');
    bytes.setUint32(4, 36 + samples.length * 2, Endian.little);
    text(8, 'WAVE');
    text(12, 'fmt ');
    bytes.setUint32(16, 16, Endian.little);
    bytes.setUint16(20, 1, Endian.little);
    bytes.setUint16(22, 1, Endian.little);
    bytes.setUint32(24, _rate, Endian.little);
    bytes.setUint32(28, _rate * 2, Endian.little);
    bytes.setUint16(32, 2, Endian.little);
    bytes.setUint16(34, 16, Endian.little);
    text(36, 'data');
    bytes.setUint32(40, samples.length * 2, Endian.little);
    for (var i = 0; i < samples.length; i++) {
      final value = samples[i].clamp(-1.0, 1.0) * 0.5;
      bytes.setInt16(44 + i * 2, (value * 32767).round(), Endian.little);
    }
    return bytes.buffer.asUint8List();
  }
}
