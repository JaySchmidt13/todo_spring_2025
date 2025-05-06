import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode = false;
  bool _useSystemTheme = true;
  Color _primaryColor = Colors.blue;

  bool get isDarkMode => _isDarkMode;
  bool get useSystemTheme => _useSystemTheme;
  Color get primaryColor => _primaryColor;

  ThemeProvider() {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    _isDarkMode = prefs.getBool('darkMode') ?? false;
    _useSystemTheme = prefs.getBool('useSystemTheme') ?? true;
    _primaryColor = Color(prefs.getInt('themeColor') ?? Colors.blue.value);
    notifyListeners();
  }

  ThemeData get theme {
    final brightness = _useSystemTheme
        ? WidgetsBinding.instance.platformDispatcher.platformBrightness
        : _isDarkMode
        ? Brightness.dark
        : Brightness.light;

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: ColorScheme.fromSeed(
        seedColor: _primaryColor,
        brightness: brightness,
      ),
    );
  }

  void updateTheme({bool? isDarkMode, bool? useSystemTheme, Color? primaryColor}) {
    if (isDarkMode != null) _isDarkMode = isDarkMode;
    if (useSystemTheme != null) _useSystemTheme = useSystemTheme;
    if (primaryColor != null) _primaryColor = primaryColor;
    notifyListeners();
  }
}