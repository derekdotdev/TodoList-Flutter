import 'package:cloud_firestore/cloud_firestore.dart';

class Task {
  final String name;
  final String user;
  String taskId;
  bool isDone;

  Task({
    required this.name,
    required this.user,
    required this.taskId,
    this.isDone = false,
  });

  void toggleDone() {
    isDone = !isDone;
  }

  void setId(var taskId) {
    this.taskId = taskId;
  }
}
