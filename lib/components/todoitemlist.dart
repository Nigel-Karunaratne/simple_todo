import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:simple_todo/components/listitemcard.dart';

import 'package:simple_todo/models/listmodel.dart';


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
        child: ListItemCard(index: index)
      ),
      onReorder:(oldIndex, newIndex) => Provider.of<TodoListModel>(context, listen: false).swap(oldIndex, newIndex),
    );
  }
}
