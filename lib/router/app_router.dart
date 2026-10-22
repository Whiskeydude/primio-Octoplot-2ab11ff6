import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../providers/app/record_provider.dart';
import '../providers/app/settings_provider.dart';
import '../providers/game/game_provider.dart';
import '../providers/gobag/gobag_provider.dart';
import '../providers/vault/vault_provider.dart';
import '../screens/game_screen.dart';
import '../screens/gobag_screen.dart';
import '../screens/menu_screen.dart';
import '../screens/vault_screen.dart';
import '../services/game_service.dart';
import '../services/gobag_service.dart';
import '../services/vault_service.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(path: '/', builder: (context, state) => const MenuScreen()),
      GoRoute(
        path: '/game',
        builder: (context, state) => ChangeNotifierProvider(
          create: (ctx) => GameProvider(
            service: ctx.read<GameService>(),
            record: ctx.read<RecordProvider>(),
            difficulty: ctx.read<SettingsProvider>().difficulty,
          ),
          child: const GameScreen(),
        ),
      ),
      GoRoute(
        path: '/vault',
        builder: (context, state) => ChangeNotifierProvider(
          create: (ctx) => VaultProvider(service: ctx.read<VaultService>())..load(),
          child: const VaultScreen(),
        ),
      ),
      GoRoute(
        path: '/gobag',
        builder: (context, state) => ChangeNotifierProvider(
          create: (ctx) => GoBagProvider(service: ctx.read<GoBagService>()),
          child: const GoBagScreen(),
        ),
      ),
    ],
  );
}
