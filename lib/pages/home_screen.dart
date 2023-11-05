// ignore_for_file: prefer_const_constructors, sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:flutter_todo_app/controllers/todo_controller.dart';
import 'package:flutter_todo_app/pages/tasks/todo_item.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

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

  List<Todo> TodosList = [];
  // List<Todo> _foundTodo = TodoController().getTodos1();
  final _TodoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getTodos();
  }

  Future<void> getTodos() async {
    QueryBuilder<ParseObject> queryPerson =
        QueryBuilder<ParseObject>(ParseObject('Todo'));
    try {
      final ParseResponse apiResponse = await queryPerson.query();
      if (apiResponse.results != null) {
        setState(() {
          TodosList = apiResponse.results!.map<Todo>((result) {
            return Todo.fromParseObject(result as ParseObject);
          }).toList();
        });
      }
    } catch (E) {
      print("error in mapping responses?");
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    TodosList.forEach((todo) {
      print(
          'ID: ${todo.todoId}, Title: ${todo.content}, Completed: ${todo.completed}');
    });
    return TodosList.isEmpty
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
                addTasksWidget(),
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
                addTasksWidget(),
              ],
            ),
          );
  }

  Widget _rowUpdate() {
    return Expanded(
        child: ListView(
      physics: const AlwaysScrollableScrollPhysics(),
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
        for (Todo todoNotComp in TodosList.reversed)
          if (!todoNotComp.completed)
            ToDoItem(
              todo: todoNotComp,
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
        for (Todo todoComp in TodosList.reversed)
          if (todoComp.completed)
            ToDoItem(
              todo: todoComp,
              onToDoChanged: _handleTodoChange,
              onDeleteItem: _deleteTodoItem,
            ),
      ],
    ));
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

  addTasksWidget() {
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
              getTodos();
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

  void _handleTodoChange(Todo Todo) {
    setState(() {
      Todo.completed = !Todo.completed;
    });
  }

  void _deleteTodoItem(String id) {
    setState(() {
      TodoController().deleteTodo(id);
      TodosList.removeWhere((item) => item.todoId == id);
    });
  }

  void _addTodoItem(String Todoo) {
    setState(() {
      // TodosList.add(Todo(
      //   id: DateTime.now().millisecondsSinceEpoch.toString(),
      //   content: Todoo,
      // ));
      Todo tempTodo = Todo(
        todoId: DateTime.now().millisecondsSinceEpoch.toString(),
        content: Todoo,
      );
      TodoController().saveTodos(tempTodo);
    });

    _TodoController.clear();
  }

  void _runFilter(String enteredKeyword) {
    List<Todo> results = [];
    if (enteredKeyword.isEmpty) {
      results = [];
    } else {
      results = TodosList.where((item) => item.content!
          .toLowerCase()
          .contains(enteredKeyword.toLowerCase())).toList();
    }

    setState(() {
      TodosList = results;
    });
  }
}
