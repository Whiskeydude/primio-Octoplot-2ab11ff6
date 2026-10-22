import '../models/purchase_models.dart';
import '../repositories/purchase_repository.dart';

class PurchaseService {
  final PurchaseRepository _repository;

  PurchaseService({required PurchaseRepository repository}) : _repository = repository;

  bool get supported => _repository.supported;
  Stream<PurchaseOutcome> get outcomes => _repository.outcomes;

  Future<bool> loadOwned() => _repository.loadCachedOwned();
  void start() => _repository.start();
  Future<StoreProduct> loadProduct() => _repository.loadProduct();
  Future<bool> buyClearance() => _repository.buy();
  Future<bool> restore() => _repository.restore();
  void dispose() => _repository.dispose();
}
