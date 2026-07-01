import 'package:flutter/material.dart';

abstract final class AppSpacing {
  static const double pageX = 28.0;
  static const double headerHeight = 64.0;
}

abstract final class AppColors {
  static const white = Color(0xFFFFFFFF);
  static const black = Color(0xFF000000);
  static const mainContrast = Color(0xFF262626);
  static const textSecondary = Color(0xFF747474);
  static const border = Color(0xFFD4D4D4);
  static const borderSecondary = Color(0xFFF2F2F2);
  static const lightBg = Color(0xFFF5F5F5);
}

// -2% letter spacing in logical pixels
double _ls(double? size, [double fallback = 14]) =>
    (size ?? fallback) * -0.02;

TextTheme _applyTextDefaults(TextTheme t) => t.copyWith(
      displayLarge: t.displayLarge?.copyWith(
        fontWeight: FontWeight.w600,
        letterSpacing: _ls(t.displayLarge?.fontSize, 57),
      ),
      displayMedium: t.displayMedium?.copyWith(
        fontWeight: FontWeight.w600,
        letterSpacing: _ls(t.displayMedium?.fontSize, 45),
      ),
      displaySmall: t.displaySmall?.copyWith(
        fontWeight: FontWeight.w600,
        letterSpacing: _ls(t.displaySmall?.fontSize, 36),
      ),
      headlineLarge: t.headlineLarge?.copyWith(
        fontWeight: FontWeight.w600,
        letterSpacing: _ls(t.headlineLarge?.fontSize, 32),
      ),
      headlineMedium: t.headlineMedium?.copyWith(
        fontWeight: FontWeight.w600,
        letterSpacing: _ls(t.headlineMedium?.fontSize, 28),
      ),
      headlineSmall: t.headlineSmall?.copyWith(
        fontWeight: FontWeight.w600,
        letterSpacing: _ls(t.headlineSmall?.fontSize, 24),
      ),
      titleLarge: t.titleLarge?.copyWith(
        fontWeight: FontWeight.w600,
        letterSpacing: _ls(t.titleLarge?.fontSize, 22),
      ),
      titleMedium: t.titleMedium?.copyWith(
        fontWeight: FontWeight.w600,
        letterSpacing: _ls(t.titleMedium?.fontSize, 16),
      ),
      titleSmall: t.titleSmall?.copyWith(
        fontWeight: FontWeight.w600,
        letterSpacing: _ls(t.titleSmall?.fontSize, 14),
      ),
      bodyLarge: t.bodyLarge?.copyWith(
        fontWeight: FontWeight.w600,
        letterSpacing: _ls(t.bodyLarge?.fontSize, 16),
      ),
      bodyMedium: t.bodyMedium?.copyWith(
        fontWeight: FontWeight.w600,
        letterSpacing: _ls(t.bodyMedium?.fontSize, 14),
      ),
      bodySmall: t.bodySmall?.copyWith(
        fontWeight: FontWeight.w600,
        letterSpacing: _ls(t.bodySmall?.fontSize, 12),
      ),
      labelLarge: t.labelLarge?.copyWith(
        fontWeight: FontWeight.w600,
        letterSpacing: _ls(t.labelLarge?.fontSize, 14),
      ),
      labelMedium: t.labelMedium?.copyWith(
        fontWeight: FontWeight.w600,
        letterSpacing: _ls(t.labelMedium?.fontSize, 12),
      ),
      labelSmall: t.labelSmall?.copyWith(
        fontWeight: FontWeight.w600,
        letterSpacing: _ls(t.labelSmall?.fontSize, 11),
      ),
    );

class AppTheme {
  static const _fontFamily = 'OpenRunde';

  static ThemeData get light {
    final base = ThemeData(useMaterial3: true, fontFamily: _fontFamily);
    return base.copyWith(
      scaffoldBackgroundColor: AppColors.white,
      splashFactory: NoSplash.splashFactory,
      highlightColor: Colors.transparent,
      colorScheme: const ColorScheme.light(
        surface: AppColors.white,
        onSurface: AppColors.mainContrast,
        primary: AppColors.black,
        onPrimary: AppColors.white,
        outline: AppColors.border,
      ),
      textTheme: _applyTextDefaults(
        base.textTheme.apply(fontFamily: _fontFamily),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          splashFactory: NoSplash.splashFactory,
          highlightColor: Colors.transparent,
        ).copyWith(
          overlayColor: const WidgetStatePropertyAll(Colors.transparent),
        ),
      ),
      appBarTheme: const AppBarTheme(
        centerTitle: false,
        toolbarHeight: AppSpacing.headerHeight,
        titleSpacing: AppSpacing.pageX,
        actionsPadding: EdgeInsets.only(right: AppSpacing.pageX),
        titleTextStyle: TextStyle(
          fontFamily: _fontFamily,
          fontSize: 28,
          fontWeight: FontWeight.w700,
          color: AppColors.mainContrast,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.black,
          foregroundColor: AppColors.white,
          disabledBackgroundColor: AppColors.border,
          minimumSize: const Size(double.infinity, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: const TextStyle(
            fontFamily: _fontFamily,
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 16 * -0.02,
            inherit: false,
          ),
        ),
      ),
    );
  }

  static ThemeData get dark {
    final base = ThemeData(useMaterial3: true, fontFamily: _fontFamily);
    return base.copyWith(
      colorScheme: const ColorScheme.dark(
        surface: Color(0xFF121212),
        primary: AppColors.white,
        onPrimary: AppColors.black,
      ),
      textTheme: _applyTextDefaults(
        base.textTheme.apply(fontFamily: _fontFamily),
      ),
    );
  }
}
