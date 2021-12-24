import 'package:flutter/material.dart';
import 'package:untitled4/screens/todo_list_screens.dart';

void main() =>runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
   return MaterialApp(
     title:"Görev Listesi",
     theme: ThemeData(
       primarySwatch: Colors.blue,
     ),
     home: TodoListScreens(),
   );
  }
}
