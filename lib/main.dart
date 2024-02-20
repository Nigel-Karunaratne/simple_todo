import 'package:flutter/material.dart';

import 'package:simple_todo/models/listmodel.dart';
import 'package:simple_todo/models/thememanager.dart';

import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_todo/views/todolistview.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); //Needed because main() is async (i think?)
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String themeStr = prefs.getString("theme") ?? "Default";
  runApp(BaseApp(startTheme: themeStr,));
}

class BaseApp extends StatelessWidget {
  final String startTheme;
  const BaseApp({super.key, required this.startTheme});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<TodoListModel>(create: (_) => TodoListModel.fromFile()),
        ChangeNotifierProvider<ThemeManager>(create: (_) => ThemeManager.fromString(startTheme)),
      ],
      builder: (context, child) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Simple TODO',
        theme: Provider.of<ThemeManager>(context, listen: true).currentTheme,
        // darkTheme: Provider.of<ThemeManager>(context, listen: true).currentDarkTheme,
        home: const TodoListView(),
      ),
    );
  }
}
