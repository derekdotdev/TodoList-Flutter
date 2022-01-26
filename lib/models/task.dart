import 'package:cloud_firestore/cloud_firestore.dart';

class Task {
  final String user;
  final String name;
  String taskId;
  bool isDone;

  // Default constructor
  Task({
    required this.user,
    required this.name,
    required this.taskId,
    required this.isDone,
  });

  void toggleDone() {
    isDone = !isDone;
  }

  void setId(var taskId) {
    this.taskId = taskId;
  }
}
