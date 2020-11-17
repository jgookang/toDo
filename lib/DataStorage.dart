import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';

class ToDoItem {
  const ToDoItem(this.title);

  final String title;

  factory ToDoItem.fromJson(Map<String, dynamic> json){
    return ToDoItem(json['title'] as String);
  }
  Map toJson() =>
      {
        'title': title,
      };
}

class DataStorage {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/data.json');
  }

  Future<List<ToDoItem>> readData() async {
    try {
      final file = await _localFile;

      // Read the file
      String contents = await file.readAsString();
      var list = jsonDecode(contents) as List;
      var toDoList = list.map((v) => ToDoItem.fromJson(v)).toList();

      return toDoList;
    } catch (e) {
      debugPrint(e.toString());
      return List<ToDoItem>();
    }
  }

  Future<File> writeData(List<ToDoItem> toDos) async {
    final file = await _localFile;
    String contents = jsonEncode(toDos);
    // Write the file
    return file.writeAsString(contents);
  }
}
