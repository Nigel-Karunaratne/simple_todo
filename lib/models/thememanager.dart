import 'package:flutter/material.dart';

class ThemeManager extends ChangeNotifier {
  final ThemeData defaultTheme = ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple), useMaterial3: true, brightness: Brightness.light);
  // final ThemeData defaultDarkTheme = ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple), useMaterial3: true, brightness: Brightness.dark);

  late ThemeData currentTheme;
  // late ThemeData currentDarkTheme;

  ThemeManager() {
    currentTheme = defaultTheme;
    // currentDarkTheme = defaultTheme;
  }

  ThemeManager.name(String themeName) {
    changeFromName(themeName);
    notifyListeners();
  }

  void changeFromName(String str) {
    switch (str) {
      case "purple":
        currentTheme = ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple), useMaterial3: true, brightness: Brightness.light);
        // currentDarkTheme = ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple), useMaterial3: true, brightness: Brightness.dark);
        break;
      case "orange":
        currentTheme = ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange), useMaterial3: true, brightness: Brightness.light);
        // currentDarkTheme = ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange), useMaterial3: true, brightness: Brightness.dark);
        break;
      case "default":
      default:
        currentTheme = defaultTheme;
        // currentDarkTheme = defaultDarkTheme;
        break;
    }
    notifyListeners();
  }

  void switchTheme(String newThemeName) {
    changeFromName(newThemeName);
    notifyListeners();
  }
}