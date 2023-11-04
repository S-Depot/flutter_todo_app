import 'dart:convert';

import 'package:flutter_todo_app/pojo/todo.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class TodoController {
  TodoController();

  List<Todo> getTodos() {
    List<Todo> todos = Todo.todoList();
    return todos;
  }

  Future<String?> saveTodos(Todo todos) async {
    final todoToSave = ParseObject('Todo')
      ..set('id', todos.id)
      ..set('content', todos.content)
      ..set('completed', todos.completed);
    await todoToSave.save();
    return todos.id;
  }
}
