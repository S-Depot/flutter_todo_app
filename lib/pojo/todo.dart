import 'dart:convert';

import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class Todo {
  final String todoId;
  final String content;
  bool completed;

  Todo({
    required this.todoId,
    required this.content,
    this.completed = false,
  });

  static List<Todo> todoList() {
    return [
      Todo(todoId: '01', content: 'Morning Excercise', completed: true),
      Todo(todoId: '02', content: 'Buy Groceries', completed: true),
      Todo(
        todoId: '03',
        content: 'Check Emails',
      ),
      Todo(
        todoId: '04',
        content: 'Team Meeting',
      ),
    ];
  }

  factory Todo.fromParseObject(ParseObject object) {
    return Todo(
      content: object.get('content') ?? 'No content',
      todoId: object.get('todoId') ?? 'No todoId',
      completed: object.get('completed'),
    );
  }
}
