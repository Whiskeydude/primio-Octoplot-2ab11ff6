import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../providers/app/record_provider.dart';
import '../providers/app/purchase_provider.dart';
import '../providers/app/settings_provider.dart';
import '../theme/responsive_layout.dart';
import '../theme/theme.dart';
import '../widgets/common/abyss_background.dart';
import '../widgets/common/stat_pill.dart';
import '../widgets/menu/difficulty_selector.dart';
import '../widgets/menu/floating_hero.dart';
import '../widgets/menu/how_to_play_dialog.dart';
import '../widgets/menu/sound_toggle.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final record = context.watch<RecordProvider>();
    final settings = context.watch<SettingsProvider>();
    final purchases = context.watch<PurchaseProvider>();
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final appColors = theme.extension<AppColorsExtension>()!;
    final size = MediaQuery.sizeOf(context);
    final heroSize = min(size.shortestSide * AppTheme.menuHeroRatio, AppTheme.menuHeroMax);
    final d = MediaQuery.disableAnimationsOf(context) ? Duration.zero : const Duration(milliseconds: 600);

    Widget reveal(Widget w, int i) =>
        w.animate(delay: d * (i * 0.2)).fadeIn(duration: d).slideY(begin: 0.2, end: 0, duration: d, curve: Curves.easeOutCubic);

    return Scaffold(
      body: AnnotatedRegion(
        value: theme.appBarTheme.systemOverlayStyle!,
        child: Stack(
          children: [
            const Positioned.fill(child: AbyssBackground()),
            SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: ResponsiveLayout.getPadding(context),
                  child: ResponsiveLayout.constrain(
                    maxWidth: AppTheme.menuContentWidth,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Center(child: FloatingHero(size: heroSize)),
                        const SizedBox(height: AppTheme.spacingMd),
                        reveal(
                          Text('OCTOPLOT',
                              textAlign: TextAlign.center,
                              style: theme.textTheme.displaySmall?.copyWith(color: colors.primary)),
                          0,
                        ),
                        const SizedBox(height: AppTheme.spacingSm),
                        reveal(
                          Text('Ten tentacles. One secret society.\nTake the world before the world notices.',
                              textAlign: TextAlign.center,
                              style: theme.textTheme.bodyLarge?.copyWith(color: colors.onSurfaceVariant)),
                          1,
                        ),
                        const SizedBox(height: AppTheme.spacingLg),
                        reveal(
                          Center(
                            child: StatPill(
                              icon: Icons.emoji_events_rounded,
                              label: record.best == null ? 'No record yet' : 'Best: ${record.best} nights',
                              tooltip: 'Fastest takeover on this device',
                            ),
                          ),
                          2,
                        ),
                        if (record.error != null) ...[
                          const SizedBox(height: AppTheme.spacingSm),
                          Text(record.error!,
                              textAlign: TextAlign.center,
                              style: theme.textTheme.bodySmall?.copyWith(color: appColors.danger)),
                        ],
                        const SizedBox(height: AppTheme.spacingLg),
                        reveal(
                          DifficultySelector(
                            selected: settings.difficulty,
                            error: settings.error,
                            onChanged: (d) {
                              settings.startSound();
                              settings.setDifficulty(d);
                            },
                          ),
                          3,
                        ),
                        const SizedBox(height: AppTheme.spacingLg),
                        reveal(
                          FilledButton.icon(
                            onPressed: () {
                              settings.startSound();
                              context.push('/game');
                            },
                            icon: const Icon(Icons.play_arrow_rounded),
                            label: const Text('Begin the plot'),
                          ),
                          3,
                        ),
                        const SizedBox(height: AppTheme.spacingSm),
                        reveal(
                          OutlinedButton.icon(
                            onPressed: () => showDialog<void>(
                              context: context,
                              builder: (_) => const HowToPlayDialog(),
                            ),
                            icon: const Icon(Icons.menu_book_rounded),
                            label: const Text('How to play'),
                          ),
                          4,
                        ),
                        const SizedBox(height: AppTheme.spacingSm),
                        reveal(
                          OutlinedButton.icon(
                            onPressed: () {
                              settings.startSound();
                              context.push('/vault');
                            },
                            icon: Icon(purchases.owned ? Icons.lock_open_rounded : Icons.lock_rounded),
                            label: Text(purchases.owned ? 'Top Secret Vault' : 'Top Secret Vault (locked)'),
                          ),
                          4,
                        ),
                        const SizedBox(height: AppTheme.spacingSm),
                        reveal(
                          SoundToggle(
                            muted: settings.muted,
                            error: settings.soundError,
                            onToggle: () {
                              settings.startSound();
                              settings.toggleMuted();
                            },
                            onRetry: settings.startSound,
                          ),
                          5,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
