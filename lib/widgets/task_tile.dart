import 'package:flutter/material.dart';

class TaskTile extends StatelessWidget {
  final bool isChecked;
  final String taskTitle;

  TaskTile({required this.taskTitle, required this.isChecked});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        '',
        style: TextStyle(
          decoration: isChecked ? TextDecoration.lineThrough : null,
        ),
      ),
      trailing: Checkbox(
        activeColor: Colors.lightBlueAccent,
        value: isChecked,
        // onChanged: toggleCheckboxState,
      ),
    );
  }
}
//
//
// (bool? checkboxState) {
// setState(() {
// isChecked = checkboxState!;
// });
