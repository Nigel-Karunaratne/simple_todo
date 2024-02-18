import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:simple_todo/models/listmodel.dart';
import 'package:simple_todo/views/listitemcard.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<TodoListModel>(
      create: (ctx) => TodoListModel.fromFile(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Simple TODO',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
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
        title: Builder(
          builder: (context) => Platform.isIOS ? const Center(child: Text("Simple TODO"),): const Center(child: Text("Simple TODO")),
        ),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: Icon(Icons.disabled_by_default_rounded, color: Theme.of(context).colorScheme.primary, semanticLabel: "Delete checked entries",),
            onPressed: () => showDialog(
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
            ),
          ),
          IconButton(
            icon: Icon(Icons.delete_forever, color: Theme.of(context).colorScheme.primary, semanticLabel: "Delete all entries",),
            onPressed: () => showDialog(
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
            ),
          ),
          IconButton(
            icon: Icon(Icons.question_mark_rounded, color: Theme.of(context).colorScheme.primary,),
            onPressed: (){},
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Provider.of<TodoListModel>(context, listen: false).appendNew(),
        child: const Icon(Icons.add),
      ),
      // body: const TodoItemList(),
      body: Consumer<TodoListModel>(
        builder: (context, value, child) => value.loaded? const TodoItemList(): const LoadingItemsDisplay()
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
      itemBuilder: (context, index) => ReorderableDragStartListener(key: Key("$index"), index: index, child: ListItemCard(index: index,)),
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