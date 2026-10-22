# Octoplot

## Overview
A turn-based conspiracy strategy game: the player is an octopus mastermind whose ten tentacles infiltrate world powers. Seize all ten before public suspicion hits 100%.

## Built vs Coming Soon
- Built: menu, how-to-play dialog, full game loop (operations, lie low, random events, win/lose overlay), best record saved on this device
- Built: three difficulty levels, per-tentacle dossiers with seized bonuses, expandable intel log, generated sound plus haptics with a mute switch (all saved on this device)
- Built: Top Secret Clearance one-time purchase unlocking the Vault (five-layer secrets onion), and a Go-bag screen (Pack / Underground tabs) reached from the exposed overlay
- Needs store setup by the owner: product "top_secret_clearance" (non-consumable) in Google Play Console and App Store Connect; the web preview shows the paywall but cannot buy
- Coming soon: nothing deferred; the attached QR code (a Google Docs link) could not be read as a spec, so the design is original

## Tech Stack & Key Decisions
- Provider + ChangeNotifier: one game provider per run, route-scoped so leaving the game discards it
- go_router with two routes; game is pushed so back returns to menu
- shared_preferences for the best record (works on web and mobile)
- flutter_soloud for sound: every sound is synthesised in code (services/synth.dart), so no audio files ship; real recordings can replace them in SoundService._loadSounds

## Architecture
- UI → GameProvider → GameService (all rules, randomness) → GameRepository (static tentacle/operation data + prefs)
- RecordProvider is app-global so the menu and end overlay share the best score; GameProvider calls it on win
- GameState is immutable; every turn produces a new state
- SettingsProvider (app-global) holds difficulty and mute; the game route reads the difficulty when it builds GameProvider
- SoundService is the only owner of the audio engine; GameFeedback maps game moments to sound and haptics, and only providers (Game, Vault, GoBag) call it
- Purchases: PurchaseRepository wraps in_app_purchase (no-op on web), grants and caches ownership in shared_preferences before finishing the transaction; PurchaseProvider is app-global so the menu and vault agree. There is no receipt server, so ownership follows the store result and is not independently verified

## Conventions
- Tentacle icons are keyed by string in models; mapping lives in widgets/game/tentacle_node.dart
- Board geometry ratios live in AppTheme; tentacleAnchor() is the single source for node positions (painter and nodes)

## Key Patterns & Gotchas
- TentaclePainter repaints from the wave controller via `repaint:`; reduce-motion swaps in a stopped animation
- Win is checked before loss, so seizing the last tentacle on a high-heat turn still wins
- Game screen switches to a side-by-side layout when width > 1.2 × height
- Seized-tentacle bonuses are applied in GameService.operationsFor, so the UI always shows effective gain, heat and cost; runOperation must receive an operation from that list. Dossier bonus text in repositories/dossier_data.dart must match those rules
- The audio engine starts on the first menu tap (browsers require a gesture); the best record is shared across difficulties

## Design System
- Deep-sea noir: near-black indigo surfaces, violet primary for seized power, teal bioluminescent glow for growing grip, coral danger for suspicion
- Unbounded for headings (bold, conspiratorial), Inter for body legibility
- Translucent GlassPanel surfaces over a generated abyss background
