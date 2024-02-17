import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class FileIO {
  static void writeFileToDocs(String filename, String text) async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final File file = File("${directory.path}/simple-todo/$filename");
    await file.writeAsString(text); //NOTE - Does not convert to os-specific line terminators (\r\n windows).
  }

  //Read from application's documents directory. Return empty string if not found.
  static Future<String> readFileFromDocs(String filename) async {
    String rval = "";
    try {
      final Directory directory = await getApplicationDocumentsDirectory();
      final File file = File("${directory.path}/simple-todo/$filename");
      if (await file.exists()) {
        rval = await file.readAsString();
      } else {
        print("creating file");
        File("${directory.path}/simple-todo/$filename").create(recursive: true);
      }
    } on MissingPluginException catch(e) {
      print("Couldn't read file. File reading is not supported for web platforms!");
    }
    catch (e) {
      print(e.toString());
      print("Couldn't read file");
    }
    return rval;
  }

}
