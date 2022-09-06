import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mess_manager/authentication/signup_screen.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Color(0xffEAF2FF),
      child: Container(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 24),
            child: Ink(
              height: 40,
              width: MediaQuery.of(context).size.width - 100,
              decoration: BoxDecoration(
                color: Colors.redAccent.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: InkWell(
                onTap: () {
                  FirebaseAuth.instance.signOut();
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => SignUpScreen()),
                      (Route<dynamic> route) => false);
                },
                child: Center(
                    child: Text(
                  "Sign out",
                  style: TextStyle(fontSize: 20),
                )),
              ),
            ),
          ),
        ],
      )),
    );
  }
}
