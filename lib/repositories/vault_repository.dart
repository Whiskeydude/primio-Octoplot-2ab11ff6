import 'package:shared_preferences/shared_preferences.dart';

import '../models/vault_models.dart';
import 'vault_data.dart';

class VaultRepository {
  static const _peeledKey = 'octoplot_vault_peeled';

  List<VaultLayer> loadLayers() => vaultLayers;

  Future<int> loadPeeled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_peeledKey) ?? 0;
  }

  Future<void> savePeeled(int count) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_peeledKey, count);
  }
}
