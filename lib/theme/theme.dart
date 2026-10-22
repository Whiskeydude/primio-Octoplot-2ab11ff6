import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

@immutable
class AppColorsExtension extends ThemeExtension<AppColorsExtension> {
  final Color success;
  final Color warning;
  final Color danger;
  final Color subtleText;
  final Color glow;
  final Color inkDim;
  final Color scrim;

  const AppColorsExtension({
    required this.success,
    required this.warning,
    required this.danger,
    required this.subtleText,
    required this.glow,
    required this.inkDim,
    required this.scrim,
  });

  @override
  AppColorsExtension copyWith({
    Color? success,
    Color? warning,
    Color? danger,
    Color? subtleText,
    Color? glow,
    Color? inkDim,
    Color? scrim,
  }) {
    return AppColorsExtension(
      success: success ?? this.success,
      warning: warning ?? this.warning,
      danger: danger ?? this.danger,
      subtleText: subtleText ?? this.subtleText,
      glow: glow ?? this.glow,
      inkDim: inkDim ?? this.inkDim,
      scrim: scrim ?? this.scrim,
    );
  }

  @override
  AppColorsExtension lerp(ThemeExtension<AppColorsExtension>? other, double t) {
    if (other is! AppColorsExtension) return this;
    return AppColorsExtension(
      success: Color.lerp(success, other.success, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      danger: Color.lerp(danger, other.danger, t)!,
      subtleText: Color.lerp(subtleText, other.subtleText, t)!,
      glow: Color.lerp(glow, other.glow, t)!,
      inkDim: Color.lerp(inkDim, other.inkDim, t)!,
      scrim: Color.lerp(scrim, other.scrim, t)!,
    );
  }
}

class AppTheme {
  AppTheme._();

  static const double spacingXs = 4.0;
  static const double spacingSm = 8.0;
  static const double spacingMd = 16.0;
  static const double spacingLg = 24.0;
  static const double spacingXl = 32.0;

  static const double radiusSmall = 8.0;
  static const double radiusMedium = 14.0;
  static const double radiusLarge = 22.0;
  static const double radiusPill = 100.0;

  static const double iconSm = 16.0;
  static const double iconMd = 22.0;
  static const double iconLg = 32.0;
  static const double iconXl = 48.0;

  static const double buttonHeight = 52.0;
  static const double meterHeight = 10.0;
  static const double nodeSize = 50.0;
  static const double nodeLabelWidth = 76.0;
  static const double ringWidth = 4.0;
  static const double dialogMaxWidth = 420.0;
  static const double menuContentWidth = 460.0;

  // Board geometry ratios (fraction of the board's side)
  static const double boardOrbitRatio = 0.37;
  static const double boardHeroRatio = 0.34;
  static const double menuHeroRatio = 0.55;
  static const double menuHeroMax = 280.0;
  static const double onionMaxSize = 260.0;
  static const double onionShrink = 0.85;
  static const double floatDistance = 10.0;

  static const double opacityDisabled = 0.38;
  static const double opacityHint = 0.6;
  static const double opacityGlass = 0.78;
  static const double opacitySoft = 0.18;
  static const double opacityBgTop = 0.35;
  static const double opacityBgBottom = 0.92;

  static const double borderDefault = 1.0;
  static const double borderSelected = 1.8;
  static const double borderThick = 2.0;

  static final ThemeData darkTheme = _buildTheme(
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF8B5CF6),
      brightness: Brightness.dark,
    ).copyWith(
      primary: const Color(0xFFB388FF),
      onPrimary: const Color(0xFF1A0B33),
      primaryContainer: const Color(0xFF3B2070),
      onPrimaryContainer: const Color(0xFFEBDDFF),
      tertiary: const Color(0xFF2EE6C5),
      onTertiary: const Color(0xFF00201A),
      surface: const Color(0xFF0D0B17),
      onSurface: const Color(0xFFEDE9FF),
      onSurfaceVariant: const Color(0xFFB5ADD6),
      surfaceContainerLow: const Color(0xFF151226),
      surfaceContainer: const Color(0xFF1B1730),
      surfaceContainerHigh: const Color(0xFF241F3D),
      surfaceContainerHighest: const Color(0xFF2E2850),
      outline: const Color(0xFF5A5285),
      outlineVariant: const Color(0xFF332D52),
    ),
    appColors: const AppColorsExtension(
      success: Color(0xFF2EE6C5),
      warning: Color(0xFFFFC857),
      danger: Color(0xFFFF5C7A),
      subtleText: Color(0xFFA59DC8),
      glow: Color(0xFF2EE6C5),
      inkDim: Color(0xFF3A3360),
      scrim: Color(0xCC07060D),
    ),
  );

  static ThemeData _buildTheme({
    required ColorScheme colorScheme,
    required AppColorsExtension appColors,
  }) {
    final textTheme = _buildTextTheme(colorScheme);
    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      materialTapTargetSize: MaterialTapTargetSize.padded,
      scaffoldBackgroundColor: colorScheme.surface,
      textTheme: textTheme,
      appBarTheme: AppBarThemeData(
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: textTheme.titleLarge,
        systemOverlayStyle: colorScheme.brightness == Brightness.light
            ? SystemUiOverlayStyle.dark
            : SystemUiOverlayStyle.light,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(0, buttonHeight),
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radiusMedium)),
          textStyle: textTheme.labelLarge,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(0, buttonHeight),
          foregroundColor: colorScheme.onSurface,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radiusMedium)),
          side: BorderSide(color: colorScheme.outline),
          textStyle: textTheme.labelLarge,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: colorScheme.primary,
          textStyle: textTheme.labelLarge,
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: colorScheme.surfaceContainerHigh,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radiusLarge)),
        titleTextStyle: textTheme.titleLarge,
        contentTextStyle: textTheme.bodyMedium,
      ),
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(radiusSmall),
        ),
        textStyle: textTheme.bodySmall?.copyWith(color: colorScheme.onSurface),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: colorScheme.surfaceContainerHigh,
        showDragHandle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(radiusLarge)),
        ),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(color: colorScheme.tertiary),
      extensions: [appColors],
    );
  }

  static TextTheme _buildTextTheme(ColorScheme colorScheme) {
    final base = GoogleFonts.interTextTheme(
      ThemeData(colorScheme: colorScheme, useMaterial3: true).textTheme,
    );
    TextStyle display(TextStyle? s, FontWeight w) => GoogleFonts.unbounded(textStyle: s, fontWeight: w);
    return base.copyWith(
      displaySmall: display(base.displaySmall, FontWeight.w800),
      headlineLarge: display(base.headlineLarge, FontWeight.w800),
      headlineMedium: display(base.headlineMedium, FontWeight.w700),
      headlineSmall: display(base.headlineSmall, FontWeight.w700),
      titleLarge: display(base.titleLarge, FontWeight.w600),
      titleMedium: base.titleMedium?.copyWith(fontWeight: FontWeight.w700),
      labelLarge: base.labelLarge?.copyWith(fontWeight: FontWeight.w700, letterSpacing: 0.4),
      labelMedium: base.labelMedium?.copyWith(color: colorScheme.onSurfaceVariant),
      bodySmall: base.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant),
    );
  }
}
