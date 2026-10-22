import 'package:flutter/foundation.dart';

import '../../services/game_service.dart';

class RecordProvider extends ChangeNotifier {
  final GameService _service;
  int? _best;
  String? _error;

  RecordProvider({required GameService service}) : _service = service;

  int? get best => _best;
  String? get error => _error;

  Future<void> load() async {
    try {
      _best = await _service.loadBestTurns();
      _error = null;
    } catch (e) {
      _error = 'Could not read your saved record: $e';
    }
    notifyListeners();
  }

  Future<void> submitWin(int turns) async {
    try {
      _best = await _service.recordWin(turns);
      _error = null;
    } catch (e) {
      _error = 'Could not save your record: $e';
    }
    notifyListeners();
  }
}
