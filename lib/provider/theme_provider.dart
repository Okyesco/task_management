import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:task_management/utilities/constants.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;
  final Box _themeBox = Hive.box(themeBox);

  ThemeProvider() {
    _loadTheme();
  }

  ThemeMode get themeMode => _themeMode;

  void toggleTheme(bool isDark) {
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    _themeBox.put('isDarkMode', isDark);
    notifyListeners();
  }

  void _loadTheme() {
    final bool isDark = _themeBox.get('isDarkMode', defaultValue: false);
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
  }
}
