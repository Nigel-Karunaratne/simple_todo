import 'package:flutter/material.dart';
import 'package:simple_todo/models/listmodel.dart';
import 'package:simple_todo/views/listitemcard.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const TodoListView(),
    );
  }
}

class TodoListView extends StatefulWidget {
  const TodoListView({super.key});

  @override
  State<TodoListView> createState() => _TodoListViewState();
}

class _TodoListViewState extends State<TodoListView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: const Text("List Name"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            onPressed: (){},
            icon: Icon(Icons.settings, color: Theme.of(context).colorScheme.primary,)
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){},
        child: const Icon(Icons.add),
      ),
      body: const TodoItemList(),
    );
  }
}

class TodoItemList extends StatefulWidget {
  const TodoItemList({super.key});

  @override
  State<TodoItemList> createState() => _TodoItemListState();
}

class _TodoItemListState extends State<TodoItemList> {

  List<TodoEntry> items = [TodoEntry(false, "Entry 1"), TodoEntry(false, "Entry 2")];

  @override
  Widget build(BuildContext context) {
    return ReorderableListView(
      buildDefaultDragHandles: false,
      // itemCount: 10,
      // itemBuilder: (context, index) => ReorderableDragStartListener(index: index, key: Key("$index"), child: ListItemCard()),
      children: [
        for (int index = 0; index < items.length; index++)
        ReorderableDragStartListener(key: Key("$index"), index: index, child: ListItemCard())
      ],
      onReorder:(oldIndex, newIndex) {
        if (oldIndex < newIndex) {
          newIndex--;


        }
      },
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