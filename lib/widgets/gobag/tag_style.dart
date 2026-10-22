import 'package:flutter/material.dart';

import '../../models/gobag_models.dart';

IconData bagTagIcon(BagTag tag) => switch (tag) {
      BagTag.cash => Icons.payments_rounded,
      BagTag.documents => Icons.badge_rounded,
      BagTag.disguise => Icons.face_retouching_natural_rounded,
      BagTag.medical => Icons.medical_services_rounded,
      BagTag.transport => Icons.pedal_bike_rounded,
      BagTag.comms => Icons.cell_tower_rounded,
      BagTag.keepsake => Icons.emoji_events_rounded,
    };

String bagTagLabel(BagTag tag) => switch (tag) {
      BagTag.cash => 'Cash',
      BagTag.documents => 'Papers',
      BagTag.disguise => 'Disguise',
      BagTag.medical => 'Medical',
      BagTag.transport => 'Transport',
      BagTag.comms => 'Comms',
      BagTag.keepsake => 'Keepsake',
    };
