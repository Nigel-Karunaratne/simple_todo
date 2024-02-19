import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: constant_identifier_names
enum ThemeType {Default, Purple, Orange, LightGreen, Blue, Red, Green, Pink}

class ThemeManager extends ChangeNotifier {
  final ThemeData defaultTheme = ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple), useMaterial3: true, brightness: Brightness.light);
  // final ThemeData defaultDarkTheme = ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple), useMaterial3: true, brightness: Brightness.dark);

  late ThemeData currentTheme;
  // late ThemeData currentDarkTheme;

  SharedPreferences? prefs;

  static Map<ThemeType, Color> themeTypes = {
    ThemeType.Purple: Colors.purple[200]!,
    ThemeType.Orange: Colors.orange[200]!,
    ThemeType.LightGreen: Colors.lightGreen[200]!,
    ThemeType.Blue: Colors.blue[200]!,
    ThemeType.Red: Colors.red[200]!,
    ThemeType.Green: Colors.green[200]!,
    ThemeType.Pink: Colors.pink[200]!,
  };

  ThemeManager() {
    currentTheme = defaultTheme;
    // currentDarkTheme = defaultTheme;
    initializePreferences();
  }

  ThemeManager.fromString(String themeName) {
    changeFromName(ThemeType.values.byName(themeName));
    notifyListeners();
    initializePreferences();
  }

  void initializePreferences() async {
    prefs = await SharedPreferences.getInstance();
  }

  void changeFromName(ThemeType type) {
    switch (type) {
      case ThemeType.Purple:
        currentTheme = ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple), useMaterial3: true, brightness: Brightness.light);
        // currentDarkTheme = ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple), useMaterial3: true, brightness: Brightness.dark);
        break;
      case ThemeType.Orange:
        currentTheme = ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange), useMaterial3: true, brightness: Brightness.light);
        // currentDarkTheme = ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange), useMaterial3: true, brightness: Brightness.dark);
        break;
      case ThemeType.LightGreen:
        currentTheme = ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightGreen), useMaterial3: true, brightness: Brightness.light);
        // currentDarkTheme = ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightGreen), useMaterial3: true, brightness: Brightness.dark);
        break;
      case ThemeType.Blue:
        currentTheme = ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue), useMaterial3: true, brightness: Brightness.light);
        // currentDarkTheme = ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue), useMaterial3: true, brightness: Brightness.dark);
        break;
      case ThemeType.Red:
        currentTheme = ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.red), useMaterial3: true, brightness: Brightness.light);
        // currentDarkTheme = ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.red), useMaterial3: true, brightness: Brightness.dark);
        break;
      case ThemeType.Green:
        currentTheme = ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.green), useMaterial3: true, brightness: Brightness.light);
        // currentDarkTheme = ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.green), useMaterial3: true, brightness: Brightness.dark);
        break;
      case ThemeType.Pink:
        currentTheme = ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.pink), useMaterial3: true, brightness: Brightness.light);
        // currentDarkTheme = ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.pink), useMaterial3: true, brightness: Brightness.dark);
        break;
      case ThemeType.Default:
      default:
        currentTheme = defaultTheme;
        // currentDarkTheme = defaultDarkTheme;
        break;
    }
    if (prefs != null) {
      prefs!.setString("theme", type.name);
    }
    notifyListeners();
  }

  void switchTheme(ThemeType theme) {
    changeFromName(theme);
    notifyListeners();
  }
}