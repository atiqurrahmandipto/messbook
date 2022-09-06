import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mess_manager/authentication/signup_screen.dart';
import 'package:mess_manager/home/main_screen.dart';

import 'authentication/role_selection_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mess Manager',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home:
          FirebaseAuth.instance.currentUser != null ? MainScreen() : MainScreen(), // replace to add myhomepage
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return SignUpScreen();
  }
}
