import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_flutter/models/task.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:todo_flutter/models/task_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo_flutter/utilities/constants.dart';
import 'package:todo_flutter/widgets/tasks_list.dart';
import 'package:todo_flutter/screens/add_task_screen.dart';

final _firestore = FirebaseFirestore.instance;
late User signedInUser;
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
  // late String taskText;

  @override
  void initState() {
    initializeTodoList();
    // initStream(userEmail);
    super.initState();
  }

  Future<void> initializeTodoList() async {
    getCurrentUser();
    await initializeStream(userEmail);
    await fetchTasksFromCloud(userEmail);
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

  Future<void> fetchTasksFromCloud(String userEmail) async {
    TaskData().getCloudTasks(userEmail);
  }

  @override
  Widget build(BuildContext context) {
    // final args = ModalRoute.of(context)!.settings.arguments as UserCredential;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlueAccent,
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                // Implement logout functionality
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
      body: Column(
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
                Text(
                  streamInitialized
                      ? '${Provider.of<TaskData>(context).taskCount} Tasks'
                      : '0 Tasks',
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
              child: const TasksList(),
            ),
          ),
        ],
      ),
    );
  }
}
//
// class TasksStream extends StatelessWidget {
//   final String userEmail;
//
//   const TasksStream({Key? key, required this.userEmail}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<QuerySnapshot>(
//         stream: _stream,
//         builder: (context, snapshot) {
//           final tasks = snapshot.data?.docs.reversed;
//           // Provider.of<TaskData>(context).clearTasksList();
//
//           for (var task in tasks!) {
//             final taskName = task.get('text');
//             final taskSender = task.get('sender');
//             final taskId = task.id;
//             final isDone = task.get('isDone');
//
//             final Task newTask = Task(
//                 name: taskName,
//                 user: taskSender,
//                 taskId: taskId,
//                 isDone: isDone);
//
//             // Provider.of<TaskData>(context).populateTasksList(newTask);
//           }
//
//           return
//         });
//   }
// }
