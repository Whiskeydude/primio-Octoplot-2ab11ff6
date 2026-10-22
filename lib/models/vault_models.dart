class VaultLayer {
  final String title;
  final String secret;
  final String clue;

  const VaultLayer({required this.title, required this.secret, required this.clue});
}

enum VaultLayerState { peeled, current, sealed }
