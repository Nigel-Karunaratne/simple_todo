import 'dart:convert';
import 'package:flutter/material.dart';

class TodoListModel extends ChangeNotifier {
  List<TodoEntry> items;

  TodoListModel(this.items);
  
  factory TodoListModel.empty() {
    return TodoListModel([]);
  }

  //Gets most recent list in json file, or makes empty if none exists
  factory TodoListModel.startupList() {
    // return TodoListModel.empty();
    return TodoListModel.fromJson(jsonDecode("{\"0\": [false, \"hello json\"],\n\"1\": [true, \"wowie zowie\"]}"));
  }

  TodoListModel.fromJson(Map<String, dynamic> json) 
    : items = [for(int i = 0; i < json.length; i++) TodoEntry(json[i.toString()][0], json[i.toString()][1])];

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

  Map<String, dynamic> toJson() {
    Map<String, dynamic> rval = {};
    for (int i = 0; i < items.length; i++) {
      rval.addAll({i.toString(): [items[i].completed, items[i].contents]});
    }
    return rval;
  }

}

class TodoEntry {
  bool completed;
  String contents;

  TodoEntry(this.completed, this.contents);
}
