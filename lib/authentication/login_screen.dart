import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../ui_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffEAF2FF),
      appBar: AppBar(
        title: Text(""),
        backgroundColor: Color(0xffEAF2FF),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            children: [
              SvgPicture.asset("assets/images/ic_logo.svg"),
              Text(
                'MessBook',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 36),
              SizedBox(height: 12),
              UIProvider.textField(context, text: "Email address"),
              SizedBox(height: 12),
              UIProvider.textField(context, text: "Password"),
              Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8, top: 8, bottom: 8),
                    child: GestureDetector(
                      onTap: () {
                        //todo: implement
                      },
                      child: Text(
                        "Forgot password?",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Color(0xff2D527C),
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  )),
              SizedBox(height: 12),
              UIProvider.actionBtn(context, text: "Log in", onTap: () {}) , // todo : implement
            ],
          ),
        ),
      ),
    );
  }
}
