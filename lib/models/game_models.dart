class Tentacle {
  final String id;
  final String name;
  final String domain;
  final String iconKey;
  final int control;

  const Tentacle({
    required this.id,
    required this.name,
    required this.domain,
    required this.iconKey,
    required this.control,
  });

  bool get isSeized => control >= 100;

  Tentacle copyWith({int? control}) => Tentacle(
        id: id,
        name: name,
        domain: domain,
        iconKey: iconKey,
        control: control ?? this.control,
      );
}

class Operation {
  final String name;
  final String description;
  final int gain;
  final int heat;
  final int cost;

  const Operation({
    required this.name,
    required this.description,
    required this.gain,
    required this.heat,
    required this.cost,
  });
}

/// Background file on a tentacle: story, infiltration targets and the bonus
/// that applies while the tentacle is fully seized.
class Dossier {
  final String lore;
  final List<String> targets;
  final String bonusName;
  final String bonusText;

  const Dossier({
    required this.lore,
    required this.targets,
    required this.bonusName,
    required this.bonusText,
  });
}

class GameEvent {
  final String title;
  final String message;
  final bool isGood;
  final String headline;

  const GameEvent({
    required this.title,
    required this.message,
    required this.isGood,
    this.headline = '',
  });
}

enum Difficulty {
  casual(
    label: 'Casual',
    description: 'Calm waters: the world barely looks your way.',
    startSuspicion: 5,
    startFunds: 40,
    eventChance: 0.25,
    badScale: 0.7,
    goodScale: 1.3,
  ),
  mastermind(
    label: 'Mastermind',
    description: 'The intended plot: balanced risks and rewards.',
    startSuspicion: 10,
    startFunds: 30,
    eventChance: 0.35,
    badScale: 1.0,
    goodScale: 1.0,
  ),
  paranoia(
    label: 'Paranoia',
    description: 'Everyone is watching: frequent, brutal events.',
    startSuspicion: 25,
    startFunds: 20,
    eventChance: 0.5,
    badScale: 1.5,
    goodScale: 0.75,
  );

  const Difficulty({
    required this.label,
    required this.description,
    required this.startSuspicion,
    required this.startFunds,
    required this.eventChance,
    required this.badScale,
    required this.goodScale,
  });

  final String label;
  final String description;
  final int startSuspicion;
  final int startFunds;
  final double eventChance;
  final double badScale;
  final double goodScale;

  String get summary =>
      'Start: $startSuspicion% suspicion, $startFunds funds. Event chance: ${(eventChance * 100).round()}% a night.';
}

enum LogTone { good, bad, neutral }

class LogEntry {
  final int turn;
  final String title;
  final String detail;
  final String headline;
  final LogTone tone;

  const LogEntry({
    required this.turn,
    required this.title,
    required this.detail,
    required this.headline,
    required this.tone,
  });
}

enum GameStatus { playing, won, lost }

class GameState {
  final List<Tentacle> tentacles;
  final int suspicion;
  final int funds;
  final int turn;
  final GameEvent? lastEvent;
  final GameStatus status;
  final Difficulty difficulty;
  final List<LogEntry> log;

  const GameState({
    required this.tentacles,
    required this.suspicion,
    required this.funds,
    required this.turn,
    required this.status,
    required this.difficulty,
    this.log = const [],
    this.lastEvent,
  });

  int get seizedCount => tentacles.where((t) => t.isSeized).length;
  int get totalControl => tentacles.fold(0, (sum, t) => sum + t.control);

  GameState copyWith({
    List<Tentacle>? tentacles,
    int? suspicion,
    int? funds,
    int? turn,
    GameStatus? status,
    GameEvent? lastEvent,
    List<LogEntry>? log,
    bool clearEvent = false,
  }) {
    return GameState(
      tentacles: tentacles ?? this.tentacles,
      suspicion: suspicion ?? this.suspicion,
      funds: funds ?? this.funds,
      turn: turn ?? this.turn,
      status: status ?? this.status,
      difficulty: difficulty,
      log: log ?? this.log,
      lastEvent: clearEvent ? null : (lastEvent ?? this.lastEvent),
    );
  }
}
