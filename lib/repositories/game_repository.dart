import 'package:shared_preferences/shared_preferences.dart';

import '../models/game_models.dart';
import 'dossier_data.dart';

class GameRepository {
  static const _bestKey = 'octoplot_best_turns';
  static const _difficultyKey = 'octoplot_difficulty';
  static const _mutedKey = 'octoplot_muted';

  List<Tentacle> loadTentacles() => const [
        Tentacle(id: 'media', name: 'Media', domain: 'Newsrooms & feeds', iconKey: 'media', control: 15),
        Tentacle(id: 'banking', name: 'Banking', domain: 'Central vaults', iconKey: 'banking', control: 10),
        Tentacle(id: 'tech', name: 'Big Tech', domain: 'Algorithms & data', iconKey: 'tech', control: 5),
        Tentacle(id: 'politics', name: 'Politics', domain: 'Ballots & lobbies', iconKey: 'politics', control: 0),
        Tentacle(id: 'pharma', name: 'Pharma', domain: 'Labs & patents', iconKey: 'pharma', control: 0),
        Tentacle(id: 'military', name: 'Military', domain: 'Bases & budgets', iconKey: 'military', control: 0),
        Tentacle(id: 'weather', name: 'Weather', domain: 'Cloud seeding', iconKey: 'weather', control: 0),
        Tentacle(id: 'food', name: 'Food', domain: 'Supply chains', iconKey: 'food', control: 5),
        Tentacle(id: 'space', name: 'Space', domain: 'Satellites & moon', iconKey: 'space', control: 0),
        Tentacle(id: 'academia', name: 'Academia', domain: 'Journals & chairs', iconKey: 'academia', control: 0),
      ];

  List<Operation> loadOperations() => const [
        Operation(name: 'Whisper', description: 'Plant rumours in the right ears', gain: 10, heat: 2, cost: 0),
        Operation(name: 'Infiltrate', description: 'Slip agents into key offices', gain: 20, heat: 6, cost: 12),
        Operation(name: 'Takeover', description: 'Seize the boardroom outright', gain: 35, heat: 12, cost: 28),
      ];

  Dossier loadDossier(String id) =>
      dossierData[id] ??
      const Dossier(lore: 'No intel on file.', targets: [], bonusName: 'None', bonusText: '');

  Future<String?> loadDifficultyName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_difficultyKey);
  }

  Future<void> saveDifficultyName(String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_difficultyKey, name);
  }

  Future<bool> loadMuted() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_mutedKey) ?? false;
  }

  Future<void> saveMuted(bool muted) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_mutedKey, muted);
  }

  Future<int?> loadBestTurns() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_bestKey);
  }

  Future<void> saveBestTurns(int turns) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_bestKey, turns);
  }
}
