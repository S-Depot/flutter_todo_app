import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class Todo {
  final String id;
  final String content;
  bool completed;

  Todo({
    required this.id,
    required this.content,
    this.completed = false,
  });

  static List<Todo> todoList() {
    return [
      Todo(id: '01', content: 'Morning Excercise', completed: true),
      Todo(id: '02', content: 'Buy Groceries', completed: true),
      Todo(
        id: '03',
        content: 'Check Emails',
      ),
      Todo(
        id: '04',
        content: 'Team Meeting',
      ),
    ];
  }
}
