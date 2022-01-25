import 'package:flutter/material.dart';
import 'package:todo_flutter/widgets/task_tile.dart';
import 'package:provider/provider.dart';
import 'package:todo_flutter/models/task_data.dart';

class TasksList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<TaskData>(
      builder: (BuildContext context, taskData, Widget? child) {
        return ListView.builder(
          itemBuilder: (context, index) {
            return TaskTile(
              taskTitle: taskData.tasks[index].name,
              isChecked: taskData.tasks[index].isDone,
              checkboxCallback: (bool? checkboxState) {
                // setState(() {
                //   // isChecked = checkboxState!;
                //   Provider.of<TaskData>(context).tasks[index].toggleDone();
                // });
              },
            );
          },
          itemCount: taskData.taskCount,
        );
      },
    );
  }
}
