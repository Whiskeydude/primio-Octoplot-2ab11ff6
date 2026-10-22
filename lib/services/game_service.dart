import 'dart:math';

import '../models/game_models.dart';
import '../repositories/game_repository.dart';

class GameService {
  final GameRepository repository;
  final Random _random;

  GameService({required this.repository, Random? random}) : _random = random ?? Random();

  /// Base operations, before any seized-tentacle bonus.
  late final List<Operation> operations = repository.loadOperations();

  static const _opHeadlines = [
    ['Rumours ripple through the {n} world', 'Anonymous tips unsettle {n} insiders'],
    ['Unknown investors quietly enter {n}', 'New faces appear in {n} back offices'],
    ['Sudden takeover stuns the {n} sector', 'Boardroom coup rocks {n} overnight'],
  ];
  static const _lieLowHeadlines = [
    'Strangely quiet night across the capital',
    'Officials report nothing unusual, again',
  ];

  GameState newGame(Difficulty d) => GameState(
        tentacles: repository.loadTentacles(),
        suspicion: d.startSuspicion,
        funds: d.startFunds,
        turn: 1,
        status: GameStatus.playing,
        difficulty: d,
      );

  bool _has(GameState s, String id) => s.tentacles.any((t) => t.id == id && t.isSeized);

  int income(GameState s) =>
      8 + s.totalControl ~/ 60 + s.seizedCount * 2 + (_has(s, 'banking') ? 6 : 0);

  int lieLowAmount(GameState s) => _has(s, 'pharma') ? 25 : 15;

  /// Operations with the bonuses of every seized tentacle already applied.
  List<Operation> operationsFor(GameState s) {
    final spin = _has(s, 'media');
    final tech = _has(s, 'tech');
    final law = _has(s, 'politics');
    final scholars = _has(s, 'academia');
    return operations.map((op) {
      var gain = op.gain;
      if (scholars && op.name == 'Whisper') gain *= 2;
      if (tech) gain += 5;
      return Operation(
        name: op.name,
        description: op.description,
        gain: gain,
        heat: spin ? (op.heat / 2).round() : op.heat,
        cost: law ? (op.cost * 0.75).round() : op.cost,
      );
    }).toList();
  }

  Dossier dossier(String id) => repository.loadDossier(id);

  /// Applies [op], which must come from [operationsFor], to a tentacle.
  GameState runOperation(GameState s, String tentacleId, Operation op) {
    if (s.status != GameStatus.playing || s.funds < op.cost) return s;
    final index = s.tentacles.indexWhere((t) => t.id == tentacleId);
    if (index < 0) return s;
    final before = s.tentacles[index];
    final after = before.copyWith(control: min(100, before.control + op.gain));
    final tentacles = [...s.tentacles]..[index] = after;

    final baseIndex = max(0, operations.indexWhere((o) => o.name == op.name));
    final variants = _opHeadlines[baseIndex];
    final headline = after.isSeized
        ? 'Final seat falls: ${before.name} now answers to no one'
        : variants[_random.nextInt(variants.length)].replaceAll('{n}', before.name);
    final costText = op.cost == 0 ? 'free' : '-${op.cost} funds';
    final entry = LogEntry(
      turn: s.turn,
      title: '${op.name}: ${before.name}',
      detail: 'Grip +${after.control - before.control}% · suspicion +${op.heat} · $costText',
      headline: headline,
      tone: LogTone.neutral,
    );

    return _endTurn(_log(
      s.copyWith(tentacles: tentacles, funds: s.funds - op.cost, suspicion: s.suspicion + op.heat),
      entry,
    ));
  }

  GameState lieLow(GameState s) {
    if (s.status != GameStatus.playing) return s;
    final amount = lieLowAmount(s);
    final entry = LogEntry(
      turn: s.turn,
      title: 'Lay low',
      detail: 'Suspicion -$amount · funds +4',
      headline: _lieLowHeadlines[_random.nextInt(_lieLowHeadlines.length)],
      tone: LogTone.neutral,
    );
    return _endTurn(_log(s.copyWith(suspicion: max(0, s.suspicion - amount), funds: s.funds + 4), entry));
  }

  GameState _log(GameState s, LogEntry entry) =>
      s.copyWith(log: [entry, ...s.log].take(60).toList());

  GameState _endTurn(GameState s) {
    final calm = s.seizedCount + (_has(s, 'food') ? 2 : 0);
    var next = s.copyWith(
      funds: s.funds + income(s),
      turn: s.turn + 1,
      suspicion: max(0, s.suspicion - calm),
      clearEvent: true,
    );
    if (_random.nextDouble() < next.difficulty.eventChance) next = _applyEvent(next);
    return _resolve(next);
  }

  int _scaled(int base, double k) => max(1, (base * k).round());

  GameState _event(GameState s, GameEvent e) => _log(
        s.copyWith(lastEvent: e),
        LogEntry(
          turn: s.turn,
          title: e.title,
          detail: e.message,
          headline: e.headline,
          tone: e.isGood ? LogTone.good : LogTone.bad,
        ),
      );

  GameState _applyEvent(GameState s) {
    final d = s.difficulty;
    final roll = _random.nextInt(4);
    if (roll < 2 && _has(s, 'weather') && _random.nextDouble() < 0.4) {
      return _event(
        s,
        const GameEvent(
          title: 'Storm cover',
          message: 'Weather control washed away a brewing scandal.',
          isGood: true,
          headline: 'Freak storm clears the streets before reporters arrive',
        ),
      );
    }
    switch (roll) {
      case 0:
        final n = _scaled(8, d.badScale);
        return _event(
          s.copyWith(suspicion: s.suspicion + n),
          GameEvent(
            title: 'Memo leaked',
            message: 'A shredder jammed. Suspicion +$n.',
            isGood: false,
            headline: 'Leaked memo hints at a secret society',
          ),
        );
      case 1:
        final targets = s.tentacles.where((t) => t.control > 0 && !t.isSeized).toList();
        if (targets.isEmpty) return s;
        if (_has(s, 'military')) {
          return _event(
            s,
            const GameEvent(
              title: 'Whistleblower silenced',
              message: 'The Military cleaned it up. No harm done.',
              isGood: true,
              headline: 'Insider recants story, citing "a misunderstanding"',
            ),
          );
        }
        final victim = targets[_random.nextInt(targets.length)];
        final n = _scaled(15, d.badScale);
        return _event(
          s.copyWith(
            tentacles: s.tentacles
                .map((t) => t.id == victim.id ? t.copyWith(control: max(0, t.control - n)) : t)
                .toList(),
          ),
          GameEvent(
            title: 'Whistleblower!',
            message: 'An insider talked. ${victim.name} grip -$n.',
            isGood: false,
            headline: '${victim.name} insider goes public with explosive claims',
          ),
        );
      case 2:
        final n = _scaled(20, d.goodScale) * (_has(s, 'space') ? 2 : 1);
        return _event(
          s.copyWith(funds: s.funds + n),
          GameEvent(
            title: 'Offshore windfall',
            message: 'A shell company paid out. Funds +$n.',
            isGood: true,
            headline: 'Mystery buyer snaps up island for record sum',
          ),
        );
      default:
        final n = _scaled(10, d.goodScale);
        return _event(
          s.copyWith(suspicion: max(0, s.suspicion - n)),
          GameEvent(
            title: 'Celebrity scandal',
            message: 'Everyone looks away. Suspicion -$n.',
            isGood: true,
            headline: 'Star caught in scandal, nation glued to screens',
          ),
        );
    }
  }

  GameState _resolve(GameState s) {
    if (s.seizedCount == s.tentacles.length) return s.copyWith(status: GameStatus.won);
    if (s.suspicion >= 100) return s.copyWith(suspicion: 100, status: GameStatus.lost);
    return s;
  }

  Future<Difficulty> loadDifficulty() async {
    final name = await repository.loadDifficultyName();
    return Difficulty.values.firstWhere((d) => d.name == name, orElse: () => Difficulty.mastermind);
  }

  Future<void> saveDifficulty(Difficulty d) => repository.saveDifficultyName(d.name);

  Future<bool> loadMuted() => repository.loadMuted();

  Future<void> saveMuted(bool muted) => repository.saveMuted(muted);

  Future<int?> loadBestTurns() => repository.loadBestTurns();

  /// Saves the run when it beats the record; returns the current best.
  Future<int> recordWin(int turns) async {
    final best = await repository.loadBestTurns();
    if (best == null || turns < best) {
      await repository.saveBestTurns(turns);
      return turns;
    }
    return best;
  }
}
