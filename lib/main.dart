import 'package:flutter/material.dart';
import 'package:flutter_todo_app/pages/home_screen.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final keyApplicationId = 'qspCwmJE1jrwykvq1UPZP8aOImKnEaG2Jzwim2IE';
  final keyClientKey = 'zYpTOlDwHaR5nHN5NFNsz8fXH4Q5pPZz8h8HIvp8';
  final keyParseServerUrl = 'https://parseapi.back4app.com';
  await Parse().initialize(keyApplicationId, keyParseServerUrl,
      clientKey: keyClientKey, debug: true);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ToDo App',
      home: HomeScreen(),
    );
  }
}
