enum PurchaseOutcomeKind { granted, pending, canceled, failed, revoked }

class PurchaseOutcome {
  final PurchaseOutcomeKind kind;
  final String? message;

  const PurchaseOutcome(this.kind, [this.message]);
}

class StoreProduct {
  final String id;
  final String title;
  final String price;

  const StoreProduct({required this.id, required this.title, required this.price});
}

class StoreException implements Exception {
  final String message;

  const StoreException(this.message);

  @override
  String toString() => message;
}
