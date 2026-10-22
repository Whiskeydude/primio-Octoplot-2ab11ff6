import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../models/game_models.dart';
import '../../services/game_feedback.dart';
import '../../services/game_service.dart';
import '../app/record_provider.dart';

class GameProvider extends ChangeNotifier {
  final GameService _service;
  final RecordProvider _record;
  final Difficulty _difficulty;
  late GameState _state;
  String? _selectedId;

  GameProvider({
    required GameService service,
    required RecordProvider record,
    required Difficulty difficulty,
  })  : _service = service,
        _record = record,
        _difficulty = difficulty {
    _state = _service.newGame(difficulty);
    GameFeedback.updateAmbience(_state.suspicion);
  }

  GameState get state => _state;
  String? get selectedId => _selectedId;
  List<Operation> get operations => _service.operationsFor(_state);
  int get income => _service.income(_state);
  int get lieLowAmount => _service.lieLowAmount(_state);
  int? get best => _record.best;

  Tentacle? get selected {
    if (_selectedId == null) return null;
    for (final t in _state.tentacles) {
      if (t.id == _selectedId) return t;
    }
    return null;
  }

  Dossier dossierFor(String id) => _service.dossier(id);

  void select(String id) {
    _selectedId = _selectedId == id ? null : id;
    GameFeedback.select();
    notifyListeners();
  }

  void runOperation(Operation op) {
    final target = selected;
    if (target == null || target.isSeized || _state.funds < op.cost) return;
    GameFeedback.operation(_service.operations.indexWhere((o) => o.name == op.name));
    _apply(_service.runOperation(_state, target.id, op));
  }

  void lieLow() {
    GameFeedback.lieLow();
    _apply(_service.lieLow(_state));
  }

  void restart() {
    _state = _service.newGame(_difficulty);
    _selectedId = null;
    GameFeedback.updateAmbience(_state.suspicion);
    notifyListeners();
  }

  void _apply(GameState next) {
    final prev = _state;
    _state = next;
    if (selected?.isSeized ?? false) _selectedId = null;
    if (next.status == GameStatus.won) {
      unawaited(_record.submitWin(next.turn).then((_) => notifyListeners()));
    }
    GameFeedback.afterTurn(prev, next);
    notifyListeners();
  }

  @override
  void dispose() {
    GameFeedback.stopAmbience();
    super.dispose();
  }
}
