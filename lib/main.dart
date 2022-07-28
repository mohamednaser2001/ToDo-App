import 'package:flutter/material.dart';
import 'package:todo_app/to_do_app_main_screen.dart';

void main() {
  runApp(ToDoApp());
}

class ToDoApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ToDoAppMainScreen(),
    );
  }
}