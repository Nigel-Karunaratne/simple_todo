import 'package:flutter/material.dart';

class TodoListModel extends ChangeNotifier {
  List<TodoEntry> items;

  TodoListModel(this.items);
  
  factory TodoListModel.empty() {
    return TodoListModel([]);
  }

  void swap(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
      newIndex--;
    }
    TodoEntry entry = items.removeAt(oldIndex);
    items.insert(newIndex, entry);
    notifyListeners();
  }
}

class TodoEntry {
  bool completed;
  String contents;

  TodoEntry(this.completed, this.contents);
}
