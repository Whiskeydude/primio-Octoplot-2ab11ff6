import 'dart:math';

import '../models/gobag_models.dart';
import '../repositories/gobag_repository.dart';

class GoBagService {
  static const int capacity = 8;
  static const int routeLength = 3;

  final GoBagRepository _repository;
  final Random _random;

  GoBagService({required GoBagRepository repository, Random? random})
      : _repository = repository,
        _random = random ?? Random();

  List<BagItem> items() => _repository.loadItems();

  List<EscapeStage> newRoute() {
    final pool = [..._repository.loadStages()]..shuffle(_random);
    return pool.take(routeLength).toList();
  }

  int weightOf(Iterable<BagItem> bag) => bag.fold(0, (sum, i) => sum + i.weight);

  int powerFor(Iterable<BagItem> bag, BagTag tag) =>
      bag.where((i) => i.tag == tag).fold(0, (sum, i) => sum + i.power);

  /// Stages are cleared in order; the first one the bag cannot cover ends the run.
  EscapeResult depart(List<EscapeStage> route, List<BagItem> bag) {
    final legs = <LegResult>[];
    var failed = false;
    for (final stage in route) {
      final have = powerFor(bag, stage.tag);
      if (failed) {
        legs.add(LegResult(stage: stage, have: have, status: StageStatus.unreached));
      } else if (have >= stage.need) {
        legs.add(LegResult(stage: stage, have: have, status: StageStatus.passed));
      } else {
        failed = true;
        legs.add(LegResult(stage: stage, have: have, status: StageStatus.failed));
      }
    }
    return EscapeResult(legs);
  }
}
