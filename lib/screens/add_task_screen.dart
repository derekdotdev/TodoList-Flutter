import 'package:flutter/material.dart';

class AddTaskScreen extends StatelessWidget {
  const AddTaskScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF757575),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0)),
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 40.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Add Task',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.lightBlueAccent),
              ),
              const TextField(
                autofocus: true,
                textCapitalization: TextCapitalization.sentences,
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 10.0,
              ),
              TextButton(
                child: const Text(
                  'Add',
                  style: TextStyle(color: Colors.white),
                ),
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.lightBlueAccent),
                ),
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
