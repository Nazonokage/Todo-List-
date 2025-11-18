import 'package:flutter/material.dart';
import '../database/database_helper.dart';

class ThemeProvider with ChangeNotifier {
  bool _isDarkMode = false;
  Color _primaryColor = Colors.blue;
  final DatabaseHelper _dbHelper = DatabaseHelper();

  bool get isDarkMode => _isDarkMode;
  Color get primaryColor => _primaryColor;

  ThemeData get themeData {
    return ThemeData(
      primaryColor: _primaryColor,
      brightness: _isDarkMode ? Brightness.dark : Brightness.light,
      scaffoldBackgroundColor: _isDarkMode ? Colors.black : Colors.white,
      appBarTheme: AppBarTheme(
        backgroundColor: _primaryColor.withOpacity(0.8),
        elevation: 0,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: _primaryColor,
      ),
    );
  }

  Future<void> loadSettings() async {
    try {
      final settings = await _dbHelper.getSettings();
      if (settings != null) {
        _isDarkMode = settings['isDarkMode'] == 1;
        _primaryColor = Color(settings['primaryColorValue']);
        notifyListeners();
      }
    } catch (e) {
      print('Error loading settings: $e');
    }
  }

  Future<void> toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    await _saveSettings();
    notifyListeners();
  }

  Future<void> setPrimaryColor(Color color) async {
    _primaryColor = color;
    await _saveSettings();
    notifyListeners();
  }

  Future<void> _saveSettings() async {
    try {
      await _dbHelper.saveSettings(_isDarkMode, _primaryColor.value);
    } catch (e) {
      print('Error saving settings: $e');
    }
  }

  List<Color> get availableColors => [
    Colors.blue,
    Colors.red,
    Colors.green,
    Colors.purple,
    Colors.orange,
    Colors.pink,
    Colors.teal,
    Colors.indigo,
  ];
}
