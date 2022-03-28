import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_flutter/models/task_data.dart';
import 'package:todo_flutter/screens/login_screen.dart';
import 'package:todo_flutter/screens/registration_screen.dart';
import 'package:todo_flutter/screens/tasks_screen.dart';
import 'package:todo_flutter/screens/welcome_screen.dart';

void main() => runApp(const TodoList());

class TodoList extends StatelessWidget {
  const TodoList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) {
        return TaskData();
      },
      child: MaterialApp(
        initialRoute: WelcomeScreen.id,
        routes: {
          WelcomeScreen.id: (context) => const WelcomeScreen(),
          RegistrationScreen.id: (context) => const RegistrationScreen(),
          LoginScreen.id: (context) => const LoginScreen(),
          TasksScreen.id: (context) => TasksScreen(),
        },
      ),
    );
  }
}
