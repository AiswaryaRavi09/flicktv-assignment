import 'package:flutter/material.dart';
import '../utils/theme_prefs.dart';

class AppThemeController extends ChangeNotifier {
  ThemeMode _mode;

  AppThemeController(bool isDark)
      : _mode = isDark ? ThemeMode.dark : ThemeMode.light;

  ThemeMode get mode   => _mode;
  bool      get isDark => _mode == ThemeMode.dark;

  void setDark(bool dark) {
    final next = dark ? ThemeMode.dark : ThemeMode.light;
    if (_mode == next) return;
    _mode = next;
    notifyListeners();
    ThemePrefs.save(dark);
  }
}

class AppThemeScope extends InheritedNotifier<AppThemeController> {
  const AppThemeScope({
    super.key,
    required AppThemeController super.notifier,
    required super.child,
  });

  static AppThemeController of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<AppThemeScope>()!.notifier!;
}