import 'dart:async';
import 'dart:convert';

import 'package:flutter_todo_app/pojo/todo.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class TodoController {
  TodoController();

  Future<Todo?> saveTodos(Todo todos) async {
    final todoToSave = ParseObject('Todo')
      ..set('todoId', todos.todoId)
      ..set('content', todos.content)
      ..set('completed', todos.completed);
    await todoToSave.save();
    return todos;
  }

  Future<void> updateTodo(String todoId, bool boolVal) async {
    final updatedTodo = ParseObject('Todo')..set('todoId', todoId);
    updatedTodo.set('completed', boolVal);
    await updatedTodo.save();
  }

  Future<void> deleteTodo(String todoId) async {
    final deleteQuery = QueryBuilder(ParseObject('Todo'))
      ..whereEqualTo('todoId', todoId);
    final response = await deleteQuery.query();
    final deletedObject = response.results!.first;
    await deletedObject.delete();
  }
}
