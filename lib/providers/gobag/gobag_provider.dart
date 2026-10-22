import 'package:flutter/foundation.dart';

import '../../models/gobag_models.dart';
import '../../services/game_feedback.dart';
import '../../services/gobag_service.dart';

class GoBagProvider extends ChangeNotifier {
  final GoBagService _service;
  final List<BagItem> items;
  final Set<String> _packed = {};
  List<EscapeStage> _route;
  EscapeResult? _result;

  GoBagProvider({required GoBagService service})
      : _service = service,
        items = service.items(),
        _route = service.newRoute();

  List<EscapeStage> get route => _route;
  EscapeResult? get result => _result;
  int get capacity => GoBagService.capacity;
  List<BagItem> get bag => items.where((i) => _packed.contains(i.id)).toList();
  int get weight => _service.weightOf(bag);

  bool isPacked(String id) => _packed.contains(id);

  bool canPack(BagItem item) => _packed.contains(item.id) || weight + item.weight <= capacity;

  int powerFor(BagTag tag) => _service.powerFor(bag, tag);

  void toggle(BagItem item) {
    if (_result != null) return;
    if (_packed.contains(item.id)) {
      _packed.remove(item.id);
    } else if (canPack(item)) {
      _packed.add(item.id);
    } else {
      return;
    }
    GameFeedback.select();
    notifyListeners();
  }

  void depart() {
    if (_result != null || _packed.isEmpty) return;
    _result = _service.depart(_route, bag);
    notifyListeners();
  }

  void restart() {
    _packed.clear();
    _result = null;
    _route = _service.newRoute();
    notifyListeners();
  }
}
