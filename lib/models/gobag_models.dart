enum BagTag { cash, documents, disguise, medical, transport, comms, keepsake }

class BagItem {
  final String id;
  final String name;
  final int weight;
  final BagTag tag;
  final int power;

  const BagItem({
    required this.id,
    required this.name,
    required this.weight,
    required this.tag,
    required this.power,
  });
}

class EscapeStage {
  final String title;
  final String story;
  final BagTag tag;
  final int need;

  const EscapeStage({
    required this.title,
    required this.story,
    required this.tag,
    required this.need,
  });
}

enum StageStatus { planning, passed, failed, unreached }

class LegResult {
  final EscapeStage stage;
  final int have;
  final StageStatus status;

  const LegResult({required this.stage, required this.have, required this.status});
}

class EscapeResult {
  final List<LegResult> legs;

  const EscapeResult(this.legs);

  bool get vanished => legs.every((l) => l.status == StageStatus.passed);
}
