import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get dark => ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0A0A0A),
        fontFamily: 'Poppins',
        colorScheme: const ColorScheme.dark(
          primary: AppColors.green,
          surface: Color(0xFF141414),
        ),
        cardColor: const Color(0xFF141414),
        dividerColor: const Color(0xFF242424),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF0A0A0A),
          foregroundColor: AppColors.textWhite,
          elevation: 0,
          iconTheme: IconThemeData(color: AppColors.textWhite),
        ),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(fontFamily: 'Poppins', color: AppColors.textWhite),
        ),
        switchTheme: SwitchThemeData(
          thumbColor: WidgetStateProperty.resolveWith((s) =>
              s.contains(WidgetState.selected) ? AppColors.green : const Color(0xFF555555)),
          trackColor: WidgetStateProperty.resolveWith((s) =>
              s.contains(WidgetState.selected)
                  ? AppColors.green.withValues(alpha: 0.4)
                  : const Color(0xFF333333)),
        ),
      );

  static ThemeData get light => ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color(0xFFF5F5F5),
        fontFamily: 'Poppins',
        colorScheme: const ColorScheme.light(
          primary: AppColors.green,
          surface: Colors.white,
        ),
        cardColor: Colors.white,
        dividerColor: const Color(0xFFE0E0E0),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFF5F5F5),
          foregroundColor: Color(0xFF1A1A1A),
          elevation: 0,
          iconTheme: IconThemeData(color: Color(0xFF1A1A1A)),
        ),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(fontFamily: 'Poppins', color: Color(0xFF1A1A1A)),
        ),
        switchTheme: SwitchThemeData(
          thumbColor: WidgetStateProperty.resolveWith((s) =>
              s.contains(WidgetState.selected) ? AppColors.green : const Color(0xFFBBBBBB)),
          trackColor: WidgetStateProperty.resolveWith((s) =>
              s.contains(WidgetState.selected)
                  ? AppColors.green.withValues(alpha: 0.4)
                  : const Color(0xFFDDDDDD)),
        ),
      );
}