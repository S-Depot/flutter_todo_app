// ignore_for_file: prefer_const_constructors, sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:flutter_todo_app/controllers/todo_controller.dart';
import 'package:flutter_todo_app/pages/tasks/todo_item.dart';

import '../pojo/todo.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeState();
}

class _HomeState extends State<HomeScreen> {
  static const Color tdRed = Color(0xFFDA4040);
  static const Color tdBlue = Color(0xFF5F52EE);

  static const Color tdBlack = Color(0xFF3A3A3A);
  static const Color tdGrey = Color(0xFF717171);

  static const Color tdBGColor = Color(0xFFEEEFF5);

  final TodosList = TodoController().getTodos();
  List<Todo> _foundTodo = [];
  final _TodoController = TextEditingController();

  @override
  void initState() {
    _foundTodo = TodosList;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return _foundTodo.isEmpty
        ? Scaffold(
            backgroundColor: tdBGColor,
            appBar: _buildAppBar(),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Center(
                  child: Image.asset(
                    'images/add_tasks.png',
                    width: size.width * 0.75,
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                addTasks(),
              ],
            ),
          )
        : Scaffold(
            backgroundColor: tdBGColor,
            appBar: _buildAppBar(),
            body: Stack(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 15,
                  ),
                  child: Column(
                    children: [
                      searchBox(),
                      _rowUpdate(),
                    ],
                  ),
                ),
                addTasks(),
              ],
            ),
          );
  }

  Widget _rowUpdate() {
    return Expanded(
        child: ListView(
      children: [
        Container(
          margin: EdgeInsets.only(
            top: 50,
            bottom: 20,
          ),
          child: Text(
            'Pending Tasks',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        for (Todo Todoo in _foundTodo.reversed)
          if (!Todoo.completed)
            ToDoItem(
              todo: Todoo,
              onToDoChanged: _handleTodoChange,
              onDeleteItem: _deleteTodoItem,
            ),
        Container(
          margin: EdgeInsets.only(
            top: 50,
            bottom: 20,
          ),
          child: Text(
            'Completed Tasks',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        for (Todo Todoo1 in _foundTodo.reversed)
          if (Todoo1.completed)
            ToDoItem(
              todo: Todoo1,
              onToDoChanged: _handleTodoChange,
              onDeleteItem: _deleteTodoItem,
            ),
      ],
    ));
  }

  void _handleTodoChange(Todo Todo) {
    setState(() {
      Todo.completed = !Todo.completed;
    });
  }

  void _deleteTodoItem(String id) {
    setState(() {
      TodosList.removeWhere((item) => item.id == id);
    });
  }

  void _addTodoItem(String Todoo) {
    setState(() {
      // TodosList.add(Todo(
      //   id: DateTime.now().millisecondsSinceEpoch.toString(),
      //   content: Todoo,
      // ));
      TodoController().saveTodos(Todo(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        content: Todoo,
      ));
    });
    _TodoController.clear();
  }

  void _runFilter(String enteredKeyword) {
    List<Todo> results = [];
    if (enteredKeyword.isEmpty) {
      results = TodosList;
    } else {
      results = TodosList.where((item) => item.content!
          .toLowerCase()
          .contains(enteredKeyword.toLowerCase())).toList();
    }

    setState(() {
      _foundTodo = results;
    });
  }

  Widget searchBox() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: TextField(
        onChanged: (value) => _runFilter(value),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(0),
          prefixIcon: Icon(
            Icons.search,
            color: tdBlack,
            size: 20,
          ),
          prefixIconConstraints: BoxConstraints(
            maxHeight: 20,
            minWidth: 25,
          ),
          border: InputBorder.none,
          hintText: 'Search',
          hintStyle: TextStyle(color: tdGrey),
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: tdBlue,
      title: const Text('My Tasks'),
    );
  }

  addTasks() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Row(children: [
        Expanded(
          child: Container(
            margin: EdgeInsets.only(
              bottom: 20,
              right: 20,
              left: 20,
            ),
            padding: EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 5,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: const [
                BoxShadow(
                  color: Colors.grey,
                  offset: Offset(0.0, 0.0),
                  blurRadius: 10.0,
                  spreadRadius: 0.0,
                ),
              ],
              borderRadius: BorderRadius.circular(10),
            ),
            child: TextField(
              controller: _TodoController,
              decoration: InputDecoration(
                  hintText: 'Add a new Todo item', border: InputBorder.none),
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(
            bottom: 20,
            right: 20,
          ),
          child: ElevatedButton(
            child: Text(
              '+',
              style: TextStyle(
                fontSize: 40,
              ),
            ),
            onPressed: () {
              _addTodoItem(_TodoController.text);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: tdBlue,
              minimumSize: Size(60, 60),
              elevation: 10,
            ),
          ),
        ),
      ]),
    );
  }
}
