import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app/routes/app_routes.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/app_theme_controller.dart';
import 'core/utils/theme_prefs.dart';
import 'features/home/view/home_view.dart';
import 'features/gift_card/view/claim_gift_card_view.dart';
import 'features/settings/view/settings_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor:            Colors.transparent,
    statusBarIconBrightness:   Brightness.light,
    systemNavigationBarColor:  Color(0xFF0A0A0A),
  ));
  final isDark = await ThemePrefs.load();
  runApp(App(isDark: isDark));
}

class App extends StatefulWidget {
  final bool isDark;
  const App({super.key, required this.isDark});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late final AppThemeController _theme;

  @override
  void initState() {
    super.initState();
    _theme = AppThemeController(widget.isDark);
  }

  @override
  void dispose() {
    _theme.dispose();
    super.dispose();
  }

  PageRoute<T> _slideRoute<T>(Widget page) => PageRouteBuilder<T>(
        pageBuilder:        (ctx, a, b) => page,
        transitionsBuilder: (ctx, a, b, child) => SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1, 0), end: Offset.zero,
          ).animate(CurvedAnimation(parent: a, curve: Curves.easeInOut)),
          child: child,
        ),
        transitionDuration: const Duration(milliseconds: 280),
      );

  @override
  Widget build(BuildContext context) {
    return AppThemeScope(
      notifier: _theme,
      child: ListenableBuilder(
        listenable: _theme,
        builder: (ctx, w) => MaterialApp(
          title:                    'Aiswarya',
          debugShowCheckedModeBanner: false,
          theme:      AppTheme.light,
          darkTheme:  AppTheme.dark,
          themeMode:  _theme.mode,
          initialRoute: AppRoutes.home,
          onGenerateRoute: (s) {
            switch (s.name) {
              case AppRoutes.settings:
                return _slideRoute(const SettingsView());
              case AppRoutes.claimGiftCard:
                return _slideRoute(const ClaimGiftCardView());
              default:
                return MaterialPageRoute(builder: (_) => const HomeView());
            }
          },
        ),
      ),
    );
  }
}