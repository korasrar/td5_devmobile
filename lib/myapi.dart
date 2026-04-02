import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:td2/models/task.dart';
import 'package:td2/models/todo.dart';
import 'package:http/http.dart' as http;

class MyAPI {
  Future<List<Task>> getTasks() async {
    await Future.delayed(Duration(seconds: 1));
    final dataString = await _loadAsset('json/tasks.json');
    final Map<String, dynamic> json = jsonDecode(dataString);
    if (json['tasks'] != null) {
      final tasks = <Task>[];
      json['tasks'].forEach((element) {
        tasks.add(Task.fromJson(element));
      });
      return tasks;
    } else {
      return [];
    }
  }



  Future<String> _loadAsset(String path) async {
    return await rootBundle.loadString(path);
  }

  // https://jsonplaceholder.typicode.com/todos
  Future<List<Todo>> getTodos() async {
    final response = await http.get(
      Uri.parse('https://jsonplaceholder.typicode.com/todos'),
    );

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      final List<dynamic> body = jsonDecode(response.body);
      return body.map((dynamic json) => Todo.fromJson(json)).toList();
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }
}
