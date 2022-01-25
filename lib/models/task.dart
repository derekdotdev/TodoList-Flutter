class Task {
  final String name;
  final String user;
  bool isDone;

  Task({required this.name, required this.user, this.isDone = false});

  void toggleDone() {
    isDone = !isDone;
  }
}
