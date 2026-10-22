import '../models/gobag_models.dart';

const List<BagItem> goBagItems = [
  BagItem(id: 'cash_roll', name: 'Envelope of cash', weight: 1, tag: BagTag.cash, power: 1),
  BagItem(id: 'gold_coins', name: 'Pouch of gold coins', weight: 2, tag: BagTag.cash, power: 3),
  BagItem(id: 'passport', name: 'Forged passport', weight: 1, tag: BagTag.documents, power: 2),
  BagItem(id: 'spare_ids', name: 'Spare ID cards', weight: 1, tag: BagTag.documents, power: 1),
  BagItem(id: 'wig', name: 'Wig and glasses', weight: 1, tag: BagTag.disguise, power: 1),
  BagItem(id: 'disguise_kit', name: 'Full disguise kit', weight: 2, tag: BagTag.disguise, power: 3),
  BagItem(id: 'bandages', name: 'Bandages', weight: 1, tag: BagTag.medical, power: 1),
  BagItem(id: 'medkit', name: 'Field medkit', weight: 2, tag: BagTag.medical, power: 2),
  BagItem(id: 'transit_pass', name: 'Prepaid transit pass', weight: 1, tag: BagTag.transport, power: 1),
  BagItem(id: 'bike', name: 'Folding bike', weight: 3, tag: BagTag.transport, power: 3),
  BagItem(id: 'burner', name: 'Burner phone', weight: 1, tag: BagTag.comms, power: 1),
  BagItem(id: 'sat_messenger', name: 'Satellite messenger', weight: 2, tag: BagTag.comms, power: 2),
  BagItem(id: 'statue', name: 'Golden octopus statue', weight: 3, tag: BagTag.keepsake, power: 0),
];

const List<EscapeStage> goBagStages = [
  EscapeStage(
    title: 'Border checkpoint',
    story: 'Guards scan every traveller. Papers decide who passes.',
    tag: BagTag.documents,
    need: 2,
  ),
  EscapeStage(
    title: 'Cash-only ferry',
    story: 'The last boat out takes no cards and asks no questions, for a price.',
    tag: BagTag.cash,
    need: 2,
  ),
  EscapeStage(
    title: 'Facial recognition arcade',
    story: 'Cameras line the only street. A familiar face will not get through.',
    tag: BagTag.disguise,
    need: 2,
  ),
  EscapeStage(
    title: 'Ambush in the alley',
    story: 'A fight is unavoidable and someone leaves it bleeding.',
    tag: BagTag.medical,
    need: 2,
  ),
  EscapeStage(
    title: 'Roadblocks everywhere',
    story: 'Cars are stopped on every highway. Only a quiet back route is open.',
    tag: BagTag.transport,
    need: 3,
  ),
  EscapeStage(
    title: 'Contact the underground',
    story: 'The network answers only to those who can reach it from far away.',
    tag: BagTag.comms,
    need: 2,
  ),
];
