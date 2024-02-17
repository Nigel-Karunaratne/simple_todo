import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:simple_todo/fileio.dart';

class TodoListModel extends ChangeNotifier {
  List<TodoEntry> items;
  bool loaded = true;

  TodoListModel(this.items);

  TodoListModel.fromFile() : items=[], loaded = false {
    updateFromFile();
  }
  
  void updateFromFile() async {
    String contents = await FileIO.readFileFromDocs("list.json");
    if (contents != "") {
      items = TodoListModel.fromJson(jsonDecode(contents)).items;
    } else {
      items = [];
    }
    loaded = true;
    notifyListeners();
  }

  TodoListModel.fromJson(Map<String, dynamic> json) 
    : items = [for(int i = 0; i < json.length; i++) TodoEntry(json[i.toString()][0], json[i.toString()][1])];

  void updateContents(int entryIndex, String newText) {
    items[entryIndex].contents = newText;
    notifyListeners();
    FileIO.writeFileToDocs("list.json", json.encode(toJson()));
  }

  void updateChecked(int entryIndex, bool newValue) {
    items[entryIndex].completed = newValue;
    notifyListeners();
    FileIO.writeFileToDocs("list.json", json.encode(toJson()));
  }

  void swap(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
      newIndex--;
    }
    TodoEntry entry = items.removeAt(oldIndex);
    items.insert(newIndex, entry);
    notifyListeners();
    FileIO.writeFileToDocs("list.json", json.encode(toJson()));
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
