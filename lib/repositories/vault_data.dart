import '../models/vault_models.dart';

const List<VaultLayer> vaultLayers = [
  VaultLayer(
    title: 'The Cover Story',
    secret:
        'Octoplot does not officially exist. Every filing calls it a "cephalopod appreciation society" with 11 members and a bake sale.',
    clue: 'Somebody signs every one of those filings.',
  ),
  VaultLayer(
    title: 'The Paper Trail',
    secret:
        'The same notary stamped every shell company: a retired lighthouse keeper who has never owned a lighthouse.',
    clue: 'Shell companies need a board. Who sits on it?',
  ),
  VaultLayer(
    title: 'The Ink Council',
    secret:
        'Seven elders vote by squirting ink into a sealed tank. Black means yes. Black also means no. Nobody has ever dared to ask.',
    clue: 'Seven elders, ten tentacles. The numbers do not match.',
  ),
  VaultLayer(
    title: 'The Eleventh Chair',
    secret:
        'The council table has eleven chairs. Ten are taken. The empty one is warm, and it faces your office.',
    clue: 'Someone has been sitting there. Find out who recruited you.',
  ),
  VaultLayer(
    title: 'The Core',
    secret:
        'You were recruited, not born. Somewhere a far larger octopus runs a far larger plot, and you are only its first layer of onion.',
    clue: 'This is the last layer. Nothing is left to hide.',
  ),
];
