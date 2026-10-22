import '../models/gobag_models.dart';
import 'gobag_data.dart';

class GoBagRepository {
  List<BagItem> loadItems() => goBagItems;

  List<EscapeStage> loadStages() => goBagStages;
}
