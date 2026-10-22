import 'package:flutter/foundation.dart';

import '../../models/vault_models.dart';
import '../../services/game_feedback.dart';
import '../../services/vault_service.dart';

class VaultProvider extends ChangeNotifier {
  final VaultService _service;
  final List<VaultLayer> layers;
  int _peeled = 0;
  String? _error;

  VaultProvider({required VaultService service})
      : _service = service,
        layers = service.layers();

  int get peeled => _peeled;
  bool get complete => _peeled >= layers.length;
  String? get error => _error;

  VaultLayerState stateOf(int index) {
    if (index < _peeled) return VaultLayerState.peeled;
    if (index == _peeled) return VaultLayerState.current;
    return VaultLayerState.sealed;
  }

  Future<void> load() async {
    try {
      _peeled = await _service.loadPeeled();
    } catch (e) {
      _error = 'Could not load your progress: $e';
    }
    notifyListeners();
  }

  Future<void> peelNext() async {
    if (complete) return;
    _peeled++;
    _error = null;
    GameFeedback.select();
    notifyListeners();
    try {
      await _service.savePeeled(_peeled);
    } catch (e) {
      _error = 'Could not save your progress: $e';
      notifyListeners();
    }
  }
}
