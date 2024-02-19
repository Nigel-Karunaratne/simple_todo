import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';

import 'package:simple_todo/components/aboutcard.dart';
import 'package:simple_todo/components/loadingitems.dart';
import 'package:simple_todo/components/nothingtosee.dart';
import 'package:simple_todo/components/todoitemlist.dart';

import 'package:simple_todo/models/listmodel.dart';
import 'package:simple_todo/models/thememanager.dart';

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