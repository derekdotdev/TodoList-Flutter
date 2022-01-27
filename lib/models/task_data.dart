import 'task.dart';
import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo_flutter/widgets/tasks_list.dart';

final _firestore = FirebaseFirestore.instance;

class TaskData extends ChangeNotifier {
  static bool tasksFetched = false;
  List<Task> tasksListMain = [];

  UnmodifiableListView<Task>? get tasks {
    return UnmodifiableListView(tasksListMain);
  }

  int get taskCount {
    return tasksListMain.length;
  }

  void clearTasksList() {
    tasksListMain.clear();
  }

  void populateTasksList(Task task) {
    tasksListMain.add(task);
    // notifyListeners();
  }

  void notifyTaskListeners() {
    notifyListeners();
  }

  Future<void> getCloudTasks(String userEmail) async {
    List<Task> newTasksList = [];

    await _firestore
        .collection('users')
        .doc(userEmail)
        .collection('tasks')
        .get()
        .then((querySnapshot) => {
              querySnapshot.docs.forEach((doc) {
                String sender = doc['sender'];
                String text = doc['text'];
                String id = doc.id;
                bool isDone = doc['isDone'];
                print('$sender, $text, $id, $isDone');
                Task newTask =
                    Task(user: sender, name: text, taskId: id, isDone: isDone);
                newTasksList.add(newTask);
              })
            });

    tasksListMain = newTasksList;
    notifyListeners();
    tasksFetched = true;
    // print('Tasks fetched: $tasksFetched');
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

    final task =
        Task(name: newTaskTitle, user: userEmail, taskId: id, isDone: false);
    tasksListMain.add(task);
    notifyTaskListeners();
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
    tasksListMain.remove(task);
    notifyListeners();
  }
}
