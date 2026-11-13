import 'package:flutter/material.dart';

/// 设计 token 沿用项目既有配色基因（不做第二套视觉体系）
class KadianColors {
  static const bg = Color(0xFFF6F6F3);
  static const card = Color(0xFFFFFFFF);
  static const sink = Color(0xFFF4F4F1);
  static const tint = Color(0xFFFAFAF7);
  static const line = Color(0xFFE8E8E2);
  static const lineStrong = Color(0xFFE2E2DC);
  static const text = Color(0xFF1C1C1A);
  static const text2 = Color(0xFF3C3C38);
  static const muted = Color(0xFF6B6B66);
  static const faint = Color(0xFF9A9A94);
  static const accent = Color(0xFF378ADD);
  static const accentInk = Color(0xFF185FA5);
  static const accentSoft = Color(0xFFE6F1FB);
  static const ok = Color(0xFF3B6D11);
  static const okSoft = Color(0xFFEAF3DE);
  static const warn = Color(0xFFBA7517);
  static const warnSoft = Color(0xFFFDF4E7);
  static const danger = Color(0xFFA32D2D);
  static const dangerSoft = Color(0xFFFCEBEA);
}

class KadianTheme {
  static ThemeData light() {
    final base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: KadianColors.bg,
      colorScheme: const ColorScheme.light(
        primary: KadianColors.accent,
        onPrimary: Colors.white,
        primaryContainer: KadianColors.accentSoft,
        onPrimaryContainer: KadianColors.accentInk,
        secondary: KadianColors.accentInk,
        surface: KadianColors.card,
        onSurface: KadianColors.text,
        error: KadianColors.danger,
        outline: KadianColors.line,
      ),
    );

    return base.copyWith(
      textTheme: base.textTheme.apply(
        bodyColor: KadianColors.text,
        displayColor: KadianColors.text,
      ),
      dividerColor: KadianColors.line,
      appBarTheme: const AppBarTheme(
        backgroundColor: KadianColors.bg,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: KadianColors.text,
          fontSize: 19,
          fontWeight: FontWeight.w600,
        ),
      ),
      cardTheme: CardTheme(
        color: KadianColors.card,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: const BorderSide(color: KadianColors.line),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: KadianColors.accent,
          foregroundColor: Colors.white,
          minimumSize: const Size(0, 44),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(9),
          ),
          textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: KadianColors.text2,
          side: const BorderSide(color: KadianColors.lineStrong),
          minimumSize: const Size(0, 44),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(9),
          ),
          textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: KadianColors.card,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(9),
          borderSide: const BorderSide(color: KadianColors.lineStrong),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(9),
          borderSide: const BorderSide(color: KadianColors.lineStrong),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(9),
          borderSide: const BorderSide(color: KadianColors.accent),
        ),
        hintStyle: const TextStyle(color: KadianColors.faint, fontSize: 14),
      ),
      chipTheme: base.chipTheme.copyWith(
        backgroundColor: KadianColors.sink,
        side: const BorderSide(color: KadianColors.line),
        labelStyle: const TextStyle(fontSize: 12.5, color: KadianColors.text2),
        shape: const StadiumBorder(),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: KadianColors.text,
        contentTextStyle: const TextStyle(color: Colors.white, fontSize: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(9),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: KadianColors.card,
        indicatorColor: KadianColors.accentSoft,
        elevation: 0,
        height: 64,
        labelTextStyle: WidgetStateProperty.resolveWith(
          (states) => TextStyle(
            fontSize: 12,
            fontWeight: states.contains(WidgetState.selected)
                ? FontWeight.w600
                : FontWeight.w400,
            color: states.contains(WidgetState.selected)
                ? KadianColors.accentInk
                : KadianColors.muted,
          ),
        ),
        iconTheme: WidgetStateProperty.resolveWith(
          (states) => IconThemeData(
            size: 22,
            color: states.contains(WidgetState.selected)
                ? KadianColors.accentInk
                : KadianColors.muted,
          ),
        ),
      ),
      navigationRailTheme: const NavigationRailThemeData(
        backgroundColor: KadianColors.card,
        indicatorColor: KadianColors.accentSoft,
        selectedIconTheme: IconThemeData(color: KadianColors.accentInk),
        unselectedIconTheme: IconThemeData(color: KadianColors.muted),
        selectedLabelTextStyle: TextStyle(
          color: KadianColors.accentInk,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelTextStyle: TextStyle(
          color: KadianColors.muted,
          fontSize: 12,
        ),
      ),
    );
  }

  static const TextStyle sectionTitle = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w600,
    color: KadianColors.muted,
    letterSpacing: 0.4,
  );

  static const TextStyle body = TextStyle(
    fontSize: 14.5,
    height: 1.75,
    color: KadianColors.text2,
  );

  static const TextStyle passageJa = TextStyle(
    fontSize: 16,
    height: 2.0,
    color: KadianColors.text,
  );

  static const TextStyle passageEn = TextStyle(
    fontSize: 15.5,
    height: 1.85,
    color: KadianColors.text,
  );
}
