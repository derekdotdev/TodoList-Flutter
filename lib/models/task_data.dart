import 'package:flutter/foundation.dart';
import 'task.dart';

class TaskData extends ChangeNotifier {
  List<Task> tasks = [
    Task(name: 'Work out'),
    Task(name: 'Eat breakfast'),
    Task(name: 'Clean studio'),
  ];
}
