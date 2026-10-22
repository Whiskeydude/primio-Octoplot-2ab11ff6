import 'package:flutter/material.dart';

import '../../models/game_models.dart';
import '../../theme/theme.dart';
import 'intel_log_header.dart';
import 'intel_log_list.dart';

/// A headline bar above [child] that opens the full history over it.
class IntelLogPanel extends StatefulWidget {
  final List<LogEntry> entries;
  final Widget child;

  const IntelLogPanel({super.key, required this.entries, required this.child});

  @override
  State<IntelLogPanel> createState() => _IntelLogPanelState();
}

class _IntelLogPanelState extends State<IntelLogPanel> {
  bool _open = false;

  @override
  Widget build(BuildContext context) {
    final entries = widget.entries;
    final latest = entries.isEmpty ? 'Intel log: nothing yet' : '“${entries.first.headline}”';

    return Column(
      children: [
        IntelLogHeader(
          label: _open ? 'Intel log' : latest,
          count: entries.length,
          open: _open,
          onToggle: () => setState(() => _open = !_open),
        ),
        const SizedBox(height: AppTheme.spacingSm),
        Expanded(
          child: Stack(
            children: [
              Positioned.fill(child: widget.child),
              if (_open) Positioned.fill(child: IntelLogList(entries: entries)),
            ],
          ),
        ),
      ],
    );
  }
}
