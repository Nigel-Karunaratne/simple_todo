import 'dart:convert';
import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:simple_todo/fileio.dart';

class TodoListModel extends ChangeNotifier {
  static const String fileName = "list.json";
  List<TodoEntry> items;
  bool loaded = true;
  RestartableTimer? saveTimer;

  TodoListModel(this.items){
    saveTimer = RestartableTimer(const Duration(seconds: 1), () => saveToDisk());
    saveTimer?.cancel();
  }

  TodoListModel.fromFile() : items=[], loaded = false {
    saveTimer = RestartableTimer(const Duration(seconds: 1), () => saveToDisk());
    saveTimer?.cancel();
    _updateFromFile();
  }

  TodoListModel.fromJson(Map<String, dynamic> json) 
    : items = [for(int i = 0; i < json.length; i++) TodoEntry(json[i.toString()][0], json[i.toString()][1])];

  void updateContents(int entryIndex, String newText) {
    items[entryIndex].contents = newText;
    notifyListeners();
    saveTimer?.reset();
  }
  
  void _updateFromFile() async {
    String contents = await FileIO.readFileFromDocs(fileName);
    if (contents != "") {
      items = TodoListModel.fromJson(jsonDecode(contents)).items;
    } else {
      items = [];
    }
    loaded = true;
    notifyListeners();
  }

  void updateChecked(int entryIndex, bool newValue) {
    items[entryIndex].completed = newValue;
    notifyListeners();
    saveTimer?.reset();
  }

  void swap(int oldIndex, int newIndex) {
    if(oldIndex == newIndex) {
      return;
    }
    if (oldIndex < newIndex) {
      newIndex--;
    }
    TodoEntry entry = items.removeAt(oldIndex);
    items.insert(newIndex, entry);
    notifyListeners();
    saveTimer?.reset();
  }

  void appendNew() {
    items.add(TodoEntry(false, ""));
    notifyListeners();
  }
  void removeEntryAt(int index) {
    items.removeAt(index);
    notifyListeners();
    saveTimer?.reset();
  }

  void saveToDisk() {
    print("SAVING");
    FileIO.writeFileToDocs(fileName, json.encode(toJson()));
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
