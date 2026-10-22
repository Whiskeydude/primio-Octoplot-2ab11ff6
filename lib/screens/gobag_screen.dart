import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../providers/gobag/gobag_provider.dart';
import '../theme/responsive_layout.dart';
import '../widgets/common/abyss_background.dart';
import '../widgets/common/screen_header.dart';
import '../widgets/gobag/pack_tab.dart';
import '../widgets/gobag/underground_tab.dart';

class GoBagScreen extends StatelessWidget {
  const GoBagScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bag = context.watch<GoBagProvider>();
    final theme = Theme.of(context);

    return DefaultTabController(
      length: 2,
      child: Builder(builder: (tabContext) {
        final tabs = DefaultTabController.of(tabContext);
        return Scaffold(
          body: AnnotatedRegion(
            value: theme.appBarTheme.systemOverlayStyle!,
            child: Stack(
              children: [
                const Positioned.fill(child: AbyssBackground()),
                SafeArea(
                  child: Padding(
                    padding: ResponsiveLayout.getPadding(context),
                    child: ResponsiveLayout.constrain(
                      Column(
                        children: [
                          ScreenHeader(title: 'Go-bag', onBack: () => context.pop()),
                          const TabBar(
                            tabs: [
                              Tab(icon: Icon(Icons.backpack_rounded), text: 'Pack'),
                              Tab(icon: Icon(Icons.visibility_off_rounded), text: 'Underground'),
                            ],
                          ),
                          Expanded(
                            child: TabBarView(
                              children: [
                                PackTab(
                                  route: bag.route,
                                  items: bag.items,
                                  capacity: bag.capacity,
                                  weight: bag.weight,
                                  powerFor: bag.powerFor,
                                  isPacked: bag.isPacked,
                                  canPack: bag.canPack,
                                  onToggle: bag.toggle,
                                  onDepart: () {
                                    bag.depart();
                                    tabs.animateTo(1);
                                  },
                                ),
                                UndergroundTab(
                                  result: bag.result,
                                  onRetry: () {
                                    bag.restart();
                                    tabs.animateTo(0);
                                  },
                                  onMenu: () => context.go('/'),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
