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
                      setState(() {
                        showModalProgressSpinner = false;
                      });
                    } catch (e) {
                      print(e);
                    }
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
