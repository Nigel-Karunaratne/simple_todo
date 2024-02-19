import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:simple_todo/models/listmodel.dart';
import 'package:simple_todo/models/thememanager.dart';
import 'package:simple_todo/views/aboutview.dart';
import 'package:simple_todo/views/listitemcard.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String themeStr = prefs.getString("theme") ?? "default";
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
        ChangeNotifierProvider<ThemeManager>(create: (_) => ThemeManager.name(startTheme)),
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

class TodoListView extends StatefulWidget {
  const TodoListView({super.key});

  @override
  State<TodoListView> createState() => _TodoListViewState();
}

enum PopupItemSelect {deleteChecked, deleteAll, changeColor}

class _TodoListViewState extends State<TodoListView> {

  final GlobalKey<ScaffoldMessengerState> _scaffoldKey = GlobalKey<ScaffoldMessengerState>();

  @override
  void initState() {
    super.initState();
    //If web, alert user that no saving :(
    if (kIsWeb) {
      SchedulerBinding.instance.addPostFrameCallback((timeStamp) => 
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            duration: const Duration(seconds: 10),
            content: const Text("Saving and Loading Lists is not supported in web browsers"),
            action: SnackBarAction(
              label: "Got it",
              onPressed: () {},
            ),
          )
        )
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: const Center(child: Text("Simple TODO")),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          PopupMenuButton<PopupItemSelect>(
            icon: Icon(Icons.more_vert, color: Theme.of(context).colorScheme.onSecondaryContainer,),
            itemBuilder: (context) => <PopupMenuItem<PopupItemSelect>>[
              const PopupMenuItem<PopupItemSelect>(
                value: PopupItemSelect.deleteChecked,
                child: Text("Delete all checked entries")
              ),
              const PopupMenuItem<PopupItemSelect>(
                value: PopupItemSelect.deleteAll,
                child: Text("Delete all entries")
              ),
              const PopupMenuItem<PopupItemSelect>(
                value: PopupItemSelect.changeColor,
                child: Text("Change app theme")
              ),
            ],
            onSelected: (value) {
              switch (value) {
                case PopupItemSelect.deleteChecked:
                  showDialog(
                    context: context,
                    barrierDismissible: true,
                    builder: (context) => AlertDialog(
                      title: const Text('Delete all checked entries?'),
                      content: SingleChildScrollView(
                        child: Text("Will delete ${Provider.of<TodoListModel>(context, listen: false).numOfCheckedEntriesStr()}."),
                      ),
                      actions: <Widget>[
                        TextButton(
                          child: const Text('Yes'),
                          onPressed: () {
                            Navigator.of(context).pop();
                            Provider.of<TodoListModel>(context, listen: false).removeAllCheckedEntries();
                          },
                        ),
                        TextButton(
                          child: const Text('No'),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ],
                    )
                  );
                  break;
                case PopupItemSelect.deleteAll:
                  showDialog(
                    context: context,
                    barrierDismissible: true,
                    builder: (context) => AlertDialog(
                      title: const Text('Delete ALL entries?'),
                      content: SingleChildScrollView(
                        child: Text("Will delete ${Provider.of<TodoListModel>(context, listen: false).numOfEntriesStr()}."),
                      ),
                      actions: <Widget>[
                        TextButton(
                          child: const Text('Yes'),
                          onPressed: () {
                            Navigator.of(context).pop();
                            Provider.of<TodoListModel>(context, listen: false).removeAllEntries();
                          },
                        ),
                        TextButton(
                          child: const Text('No'),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ],
                    )
                  );
                  break;
                case PopupItemSelect.changeColor:
                  showDialog(
                    context: context,
                    barrierDismissible: true,
                    builder: (context) => AlertDialog(
                      title: const Text("Change color scheme"),
                      content: SingleChildScrollView(
                        child: Column(
                          children: [
                            IconButton(
                              onPressed: () => Provider.of<ThemeManager>(context, listen: false).changeFromName("purple"),
                              icon: Icon(
                                Icons.circle,
                                color: Colors.purple[200],
                              ),
                            ),
                            IconButton(
                              onPressed: () => Provider.of<ThemeManager>(context, listen: false).changeFromName("orange"),
                              icon: Icon(
                                Icons.circle,
                                color: Colors.orange[200],
                              ),
                            )
                          ],
                        ),
                      ),
                      actions: [
                        TextButton(
                          child: const Text('Exit'),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ],
                    )
                  );
                  break;
              }
            },
          ),
        ],
        leading: IconButton(
          icon: Icon(Icons.question_mark_rounded, color: Theme.of(context).colorScheme.onPrimaryContainer,),
          onPressed: () => showDialog(
            context: context,
            barrierDismissible: true,
            builder: (context) => AlertDialog(
              title: const Text("About Simple TODO"),
              content: const AboutAppView(),
              actions: <Widget>[
                TextButton(
                  child: const Text("OK"),
                  onPressed: () => Navigator.of(context).pop(),
                )
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Provider.of<TodoListModel>(context, listen: false).appendNew(),
        child: const Icon(Icons.add),
        // elevation: 0,
        // hoverElevation: 0,
        // shape: RoundedRectangleBorder(side: BorderSide(width: 2,color: Theme.of(context).colorScheme.onPrimaryContainer),borderRadius: BorderRadius.circular(20)),
      ),
      // body: const TodoItemList(),
      body: Consumer<TodoListModel>(
        builder: (context, value, child) {
          if (!value.loaded) {
            return const LoadingItemsDisplay();
          }
          if (value.items.isEmpty) {
            return const NothingToSee();
          }
          return const TodoItemList();
        },
        
      ),
    );
  }
}

class TodoItemList extends StatefulWidget {
  const TodoItemList({super.key});

  @override
  State<TodoItemList> createState() => _TodoItemListState();
}

class _TodoItemListState extends State<TodoItemList> {
  @override
  Widget build(BuildContext context) {
    return ReorderableListView.builder(
      buildDefaultDragHandles: false,
      itemCount: Provider.of<TodoListModel>(context, listen: true).items.length,
      itemBuilder: (context, index) => ReorderableDragStartListener(
        key: Key("rdsl$index"),
        index: index,
        child: ListItemCard(index: index,)
      ),
      onReorder:(oldIndex, newIndex) => Provider.of<TodoListModel>(context, listen: false).swap(oldIndex, newIndex),
    );
  }
}

class NothingToSee extends StatelessWidget {
  const NothingToSee({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 200,
        height: 200,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primaryContainer,
          borderRadius: const BorderRadius.all(Radius.elliptical(50, 40))
        ),
        child: const Center(
          child: Text(
            "Nothing to do.\nTo add, use the + button.",
            textAlign: TextAlign.center,
          )
        ),
      ),
    );
  }
}

class LoadingItemsDisplay extends StatelessWidget {
  const LoadingItemsDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Loading..."),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10.0),
          ),
          CircularProgressIndicator(
            semanticsLabel: "Loading List items.",
          ),
        ],
      ),
    );
  }
}