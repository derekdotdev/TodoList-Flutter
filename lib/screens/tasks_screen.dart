import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_flutter/models/task.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:todo_flutter/models/task_data.dart';
import 'package:todo_flutter/widgets/task_tile.dart';
import 'package:todo_flutter/widgets/tasks_list.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo_flutter/utilities/constants.dart';
import 'package:todo_flutter/screens/add_task_screen.dart';

final _firestore = FirebaseFirestore.instance;
late User signedInUser;
bool _loading = true;
late Stream<QuerySnapshot> _stream;
bool streamInitialized = false;

class TasksScreen extends StatefulWidget {
  static const String id = '/tasks-screen';

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  final _auth = FirebaseAuth.instance;
  late User signedInUser;
  late String userEmail;
  late int numberOfTasks = 0;
  final TaskData taskData = TaskData();

  @override
  void initState() {
    initializeTodoList();
    super.initState();
  }

  Future<void> initializeTodoList() async {
    await getCurrentUser();
    await initializeStream(userEmail);
    await getCloudTasks(userEmail);
  }

  Future<void> getCurrentUser() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        signedInUser = user;
        userEmail = signedInUser.email!;
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> initializeStream(String userEmail) async {
    try {
      _stream = _firestore
          .collection('users')
          .doc(userEmail)
          .collection('tasks')
          .orderBy('timestamp')
          .snapshots();
      streamInitialized = true;
    } catch (e) {
      print(e);
    }
  }

  Future<void> getCloudTasks(String userEmail) async {
    TaskData taskData = TaskData();
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
                print('new Task: $sender, $text, $id, $isDone');
                Task newTask =
                    Task(user: sender, name: text, taskId: id, isDone: isDone);
                newTasksList.add(newTask);
                numberOfTasks++;
              })
            });
    setState(() {
      taskData.tasksListMain = newTasksList;
      TaskData.tasksFetched = true;
      numberOfTasks;
      print('Task Data Fetched: ${TaskData.tasksFetched}');
    });
    _loading = false;
  }

  String numTasks() {
    String resultText = '';
    int result = 0;

    setState(() {
      result = Provider.of<TaskData>(context).taskCount;

      if (result == 1) {
        resultText = '$result Task';
      } else {
        resultText = '$result Tasks';
      }

      result;
      resultText;
    });
    taskData.notifyTaskListeners();

    return resultText;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlueAccent,
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                _auth.signOut();
                Navigator.pop(context);
              }),
        ],
      ),
      backgroundColor: Colors.lightBlueAccent,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.lightBlueAccent,
        child: const Icon(Icons.add),
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (context) => SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: AddTaskScreen(
                  (newTaskTitle) {
                    Navigator.pop(context);
                  },
                  userEmail,
                ),
              ),
            ),
          );
        },
      ),
      body: !_loading
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.only(
                      top: 60.0, left: 30.0, right: 30.0, bottom: 30.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Hero(
                        tag: kHeroTag,
                        child: CircleAvatar(
                          child: Icon(
                            Icons.list,
                            color: Colors.lightBlueAccent,
                            size: 30.0,
                          ),
                          backgroundColor: Colors.white,
                          radius: 30.0,
                        ),
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      const Text(
                        'Todo List',
                        style: TextStyle(
                          fontSize: 50.0,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      streamInitialized
                          ? TaskCount(numTasks())
                          : Text(
                              '$numberOfTasks Tasks',
                              style: const TextStyle(
                                fontSize: 24.0,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                    ],
                  ),
                ),
                // streamInitialized ? TasksStream(userEmail: userEmail) : Text('nada'),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    height: 300.0,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20.0),
                        topRight: Radius.circular(20.0),
                      ),
                    ),
                    child: streamInitialized
                        ? TasksStream(userEmail: userEmail)
                        : const Center(
                            child: CircularProgressIndicator(
                              backgroundColor: Colors.lightBlueAccent,
                            ),
                          ),
                  ),
                ),
              ],
            )
          : const Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.lightBlueAccent,
              ),
            ),
    );
  }
}

class TaskCount extends StatelessWidget {
  final String numTasks;
  TaskCount(this.numTasks, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      numTasks,
      style: const TextStyle(
        fontSize: 24.0,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
    );
  }
}

class TasksStream extends StatelessWidget {
  final String userEmail;

  const TasksStream({Key? key, required this.userEmail}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: _stream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.lightBlueAccent,
              ),
            );
          }

          final tasks = snapshot.data?.docs.reversed;
          Provider.of<TaskData>(context).clearTasksList();

          List<TaskTile> taskTiles = [];

          for (var task in tasks!) {
            final taskName = task.get('text');
            final taskSender = task.get('sender');
            final taskId = task.id;
            final isDone = task.get('isDone');

            final Task newTask = Task(
                name: taskName,
                user: taskSender,
                taskId: taskId,
                isDone: isDone);

            Provider.of<TaskData>(context, listen: false)
                .populateTasksList(newTask);
          }

          // Provider.of<TaskData>(context).notifyTaskListeners();
          return TasksList();
        });
  }
}
