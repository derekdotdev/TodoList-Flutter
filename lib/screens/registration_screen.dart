import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:todo_flutter/screens/tasks_screen.dart';
import 'package:todo_flutter/widgets/rounded_button.dart';
import 'package:todo_flutter/utilities/constants.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

final _firestore = FirebaseFirestore.instance;

class RegistrationScreen extends StatefulWidget {
  static const String id = '/registration-screen';

  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  // Instantiate firebase auth instance
  final _auth = FirebaseAuth.instance;
  bool showModalProgressSpinner = false;
  String email = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showModalProgressSpinner,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const Flexible(
                child: Hero(
                  tag: kHeroTag,
                  child: CircleAvatar(
                    child: Icon(
                      Icons.list,
                      size: kIconSizeLarge,
                      color: Colors.white,
                    ),
                    backgroundColor: Colors.lightBlueAccent,
                    radius: kCircleAvatarSizeLarge,
                  ),
                ),
              ),
              const SizedBox(
                height: 48.0,
              ),
              TextField(
                autofocus: true,
                keyboardType: TextInputType.emailAddress,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  email = value;
                },
                decoration: kTextFieldDecoration.copyWith(
                  hintText: 'Enter your email',
                ),
              ),
              const SizedBox(
                height: 8.0,
              ),
              // Password entry
              TextField(
                obscureText: true,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  password = value;
                },
                decoration: kTextFieldDecoration.copyWith(
                  hintText: 'Enter your password',
                ),
              ),
              const SizedBox(
                height: 24.0,
              ),
              RoundedButton(
                colour: Colors.lightBlueAccent,
                title: 'Register',
                onPress: () async {
                  setState(() {
                    showModalProgressSpinner = true;
                  });
                  try {
                    final newUser = await _auth.createUserWithEmailAndPassword(
                        email: email, password: password);
                    if (newUser.additionalUserInfo?.isNewUser != null) {
                      // Create a firestore collection with one default item
                      _firestore
                          .collection('users')
                          .doc(email)
                          .collection('tasks')
                          .add({
                        'sender': email,
                        'text': 'Long-press to delete tasks when complete! =)',
                        'isDone': false,
                        'timestamp': FieldValue.serverTimestamp()
                      });
                      Navigator.pushNamed(context, TasksScreen.id);
                    }
                    setState(() {
                      showModalProgressSpinner = false;
                    });
                  } catch (e) {
                    // Determine whether email or password rejected and
                    // Display appropriate AlertDialog
                    String alertTitle = '';
                    String promptText = '';
                    if (e.toString().contains('password')) {
                      alertTitle = 'Invalid Password';
                      promptText =
                          'Password must be at least six characters. \nPlease try again';
                    } else if (e.toString().contains('email')) {
                      alertTitle = 'Invalid Email Format';
                      promptText = 'Please try again';
                    }
                    _showMyDialog(alertTitle, promptText);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showMyDialog(String alertTitle, String promptText) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(alertTitle),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(promptText),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
