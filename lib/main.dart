import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_flutter/models/task_data.dart';
import 'package:todo_flutter/screens/login_screen.dart';
import 'package:todo_flutter/screens/registration_screen.dart';
import 'package:todo_flutter/screens/tasks_screen.dart';
import 'package:todo_flutter/screens/welcome_screen.dart';

void main() => runApp(TodoList());

class TodoList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) {
        return TaskData();
      },
      child: MaterialApp(
        initialRoute: WelcomeScreen.id,
        routes: {
          WelcomeScreen.id: (context) => WelcomeScreen(),
          RegistrationScreen.id: (context) => RegistrationScreen(),
          LoginScreen.id: (context) => LoginScreen(),
          TasksScreen.id: (context) => TasksScreen(),
        },
      ),
    );
  }
}
