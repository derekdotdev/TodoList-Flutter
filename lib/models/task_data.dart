import 'package:cloud_firestore/cloud_firestore.dart';

import 'task.dart';
import 'dart:collection';
import 'package:flutter/foundation.dart';

final _firestore = FirebaseFirestore.instance;

class TaskData extends ChangeNotifier {
  final List<Task> _tasks = [
    Task(name: 'Work out', user: 'derek@derek.com'),
    Task(name: 'Eat breakfast', user: 'derek@derek.com'),
    Task(name: 'Clean studio', user: 'derek@derek.com'),
  ];

  UnmodifiableListView<Task>? get tasks {
    return UnmodifiableListView(_tasks);
  }

  int get taskCount {
    return _tasks.length;
  }

  void addTask(String newTaskTitle, String userEmail) {
    final task = Task(name: newTaskTitle, user: userEmail);
    _firestore.collection('tasks').add({
      'sender': task.user,
      'text': task.name,
      'timestamp': FieldValue.serverTimestamp(),
    });
    _tasks.add(task);
    notifyListeners();
  }

  void updateTask(Task task) {
    task.toggleDone();
    notifyListeners();
  }

  void deleteTask(Task task) {
    _tasks.remove(task);
    notifyListeners();
  }
}
