import 'task.dart';
import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:todo_flutter/widgets/tasks_list.dart';

final _firestore = FirebaseFirestore.instance;

class TaskData extends ChangeNotifier {
  final List<Task> _tasks = [];

  UnmodifiableListView<Task>? get tasks {
    return UnmodifiableListView(_tasks);
  }

  int get taskCount {
    return _tasks.length;
  }

  void clearTasksList() {
    _tasks.clear();
  }

  void populateTasksList(Task task) {
    _tasks.add(task);
    // notifyListeners();
  }

  void getCloudTasks(String userEmail) {
    _firestore
        .collection('users')
        .doc(userEmail)
        .collection('tasks')
        .get()
        .then((value) => value.docs.forEach((doc) {
              print(doc['text']);
            }));
  }

  // DocumentReference<Map<String, dynamic>>
  void addCloudTask(String newTaskTitle, String userEmail) async {
    DocumentReference<Map<String, dynamic>> ref = await _firestore
        .collection('users')
        .doc(userEmail)
        .collection('tasks')
        .add({
      'sender': userEmail,
      'text': newTaskTitle,
      'isDone': false,
      'timestamp': FieldValue.serverTimestamp(),
    });

    String id = ref.id;

    final task = Task(name: newTaskTitle, user: userEmail, taskId: id);
    _tasks.add(task);
    notifyListeners();
  }

  void updateTaskDone(Task task) {
    task.toggleDone();
    bool newVal = task.isDone;
    _firestore
        .collection('users')
        .doc(task.user)
        .collection('tasks')
        .doc(task.taskId)
        .update({'isDone': newVal});
    notifyListeners();
  }

  void deleteCloudTask(Task task) {
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
