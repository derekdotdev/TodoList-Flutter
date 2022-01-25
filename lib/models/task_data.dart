import 'package:cloud_firestore/cloud_firestore.dart';

import 'task.dart';
import 'dart:collection';
import 'package:flutter/foundation.dart';

final _firestore = FirebaseFirestore.instance;

class TaskData extends ChangeNotifier {
  final List<Task> _tasks = [
    // Task(name: 'Work out', user: 'derek@derek.com'),
    // Task(name: 'Eat breakfast', user: 'derek@derek.com'),
    // Task(name: 'Clean studio', user: 'derek@derek.com'),
  ];

  UnmodifiableListView<Task>? get tasks {
    return UnmodifiableListView(_tasks);
  }

  int get taskCount {
    return _tasks.length;
  }

// DocumentReference<Map<String, dynamic>>
  void addTask(String newTaskTitle, String userEmail) async {
    DocumentReference<Map<String, dynamic>> ref = await _firestore
        .collection('users')
        .doc(userEmail)
        .collection('tasks')
        .add({
      'sender': userEmail,
      'text': newTaskTitle,
      'timestamp': FieldValue.serverTimestamp(),
    });

    String id = ref.id;

    final task = Task(name: newTaskTitle, user: userEmail, taskId: id);
    // String taskId = ref as String;
    // task.setId(ref);
    print(ref.toString());
    _tasks.add(task);
    notifyListeners();
  }

  void updateTask(Task task) {
    task.toggleDone();
    notifyListeners();
  }

  void deleteTask(Task task) {
    _firestore
        .collection('users')
        .doc(task.user)
        .collection('tasks')
        .doc(task.taskId)
        .delete();
    _tasks.remove(task);
    notifyListeners();
  }
}
