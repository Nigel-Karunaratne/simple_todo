import 'package:flutter/material.dart';
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