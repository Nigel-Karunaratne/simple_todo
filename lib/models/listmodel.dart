import 'package:flutter/material.dart';

class TodoListModel extends ChangeNotifier {
  List<TodoEntry> items;

  TodoListModel(this.items);
  
  factory TodoListModel.empty() {
    return TodoListModel([]);
  }

  void updateContents(int entryIndex, String newText) {
    items[entryIndex].contents = newText;
    notifyListeners();
  }

  void updateChecked(int entryIndex, bool newValue) {
    items[entryIndex].completed = newValue;
    notifyListeners();
  }

  void swap(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
      newIndex--;
    }
    TodoEntry entry = items.removeAt(oldIndex);
    items.insert(newIndex, entry);
    notifyListeners();
  }

  void appendNew() {
    items.add(TodoEntry(false, ""));
    notifyListeners();
  }
}

class TodoEntry {
  bool completed;
  String contents;

  TodoEntry(this.completed, this.contents);
}
