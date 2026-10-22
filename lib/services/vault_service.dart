import '../models/vault_models.dart';
import '../repositories/vault_repository.dart';

class VaultService {
  final VaultRepository _repository;

  VaultService({required VaultRepository repository}) : _repository = repository;

  List<VaultLayer> layers() => _repository.loadLayers();

  Future<int> loadPeeled() async {
    final saved = await _repository.loadPeeled();
    return saved.clamp(0, layers().length).toInt();
  }

  Future<void> savePeeled(int count) => _repository.savePeeled(count);
}
