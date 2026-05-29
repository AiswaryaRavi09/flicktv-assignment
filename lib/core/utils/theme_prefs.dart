import 'dart:io';

class ThemePrefs {
  ThemePrefs._();

  static const _filename = 'flicktv_theme_pref';

  static File _file() {
    String dir;
    if (Platform.isAndroid) {
      const pkg = 'flicktv.aiswarya';
      final candidates = [
        '/data/user/0/$pkg/files',
        '/data/data/$pkg/files',
      ];
      dir = candidates.firstWhere(
        (p) => Directory(p).existsSync(),
        orElse: () => Directory.systemTemp.path,
      );
    } else {
      final home = Platform.environment['HOME'] ?? '';
      dir = home.isEmpty ? Directory.systemTemp.path : '$home/Documents';
    }
    return File('$dir/$_filename');
  }

  static Future<bool> load() async {
    try {
      final f = _file();
      if (!f.existsSync()) return true;
      return f.readAsStringSync().trim() == 'dark';
    } catch (_) {
      return true;
    }
  }

  static Future<void> save(bool isDark) async {
    try {
      final f = _file();
      f.parent.createSync(recursive: true);
      f.writeAsStringSync(isDark ? 'dark' : 'light');
    } catch (_) {}
  }
}