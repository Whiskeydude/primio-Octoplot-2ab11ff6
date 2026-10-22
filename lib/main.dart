import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/app/record_provider.dart';
import 'providers/app/purchase_provider.dart';
import 'providers/app/settings_provider.dart';
import 'repositories/game_repository.dart';
import 'repositories/gobag_repository.dart';
import 'repositories/purchase_repository.dart';
import 'repositories/vault_repository.dart';
import 'router/app_router.dart';
import 'services/game_service.dart';
import 'services/gobag_service.dart';
import 'services/purchase_service.dart';
import 'services/vault_service.dart';
import 'theme/theme.dart';

void main() => runApp(const OctoplotApp());

class OctoplotApp extends StatelessWidget {
  const OctoplotApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (_) => GameRepository()),
        Provider(create: (ctx) => GameService(repository: ctx.read<GameRepository>())),
        ChangeNotifierProvider(
          create: (ctx) => RecordProvider(service: ctx.read<GameService>())..load(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => SettingsProvider(service: ctx.read<GameService>())..load(),
        ),
        Provider(create: (_) => PurchaseRepository()),
        Provider(create: (ctx) => PurchaseService(repository: ctx.read<PurchaseRepository>())),
        ChangeNotifierProvider(
          create: (ctx) => PurchaseProvider(service: ctx.read<PurchaseService>())..load(),
        ),
        Provider(create: (_) => VaultRepository()),
        Provider(create: (ctx) => VaultService(repository: ctx.read<VaultRepository>())),
        Provider(create: (_) => GoBagRepository()),
        Provider(create: (ctx) => GoBagService(repository: ctx.read<GoBagRepository>())),
      ],
      child: MaterialApp.router(
        title: 'Octoplot',
        theme: AppTheme.darkTheme,
        routerConfig: AppRouter.router,
      ),
    );
  }
}
