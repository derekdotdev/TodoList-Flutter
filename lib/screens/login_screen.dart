import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:todo_flutter/utilities/constants.dart';
import 'package:todo_flutter/screens/tasks_screen.dart';
import 'package:todo_flutter/widgets/rounded_button.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class LoginScreen extends StatefulWidget {
  static const String id = '/login-screen';
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Instantiate firebase auth instance
  final _auth = FirebaseAuth.instance;
  bool showModalProgressSpinner = false;
  String email = '';
  String password = '';

  String getErrorMessage(String error) {
    if (error.contains('user-not-found')) {
      return 'Invalid email address';
    } else if (error.contains('wrong-password')) {
      return 'Invalid password';
    } else {
      return 'Invalid email or password';
    }
  }

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
              // Email entry
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
              //RoundedButton(Colors.lightBlueAccent, ChatScreen.id, 'Log In'),
              RoundedButton(
                  colour: Colors.lightBlueAccent,
                  title: 'Log In',
                  onPress: () async {
                    setState(() {
                      showModalProgressSpinner = true;
                    });
                    try {
                      final newUser = await _auth.signInWithEmailAndPassword(
                          email: email, password: password);
                      if (newUser.additionalUserInfo?.isNewUser != null) {
                        Navigator.pushNamed(context, TasksScreen.id);
                      }
                    } catch (e) {
                      print(e);
                      var message = getErrorMessage(e.toString());
                      await _showAlertDialog(context, message);
                    } finally {
                      setState(() {
                        showModalProgressSpinner = false;
                      });
                    }
                  }),
            ],
          ),
        ),
      ),
    );
  }
}

_showAlertDialog(BuildContext context, String errorMessage) {
  // set up the button
  Widget okButton = TextButton(
    child: const Text('OK'),
    onPressed: () {
      Navigator.of(context).pop();
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: const Text(
      'Error',
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    ),
    content: Text(
      errorMessage,
      style: const TextStyle(fontSize: 14),
    ),
    actions: [
      okButton,
    ],
  );

  // show the dialog
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      });
}
