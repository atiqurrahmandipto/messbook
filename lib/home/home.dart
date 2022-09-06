import 'package:flutter/material.dart';
import 'package:mess_manager/invitation/member_invitation_screen.dart';
import 'package:mess_manager/ui_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: UIProvider.actionBtn(context, text: "Invite members", onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) =>
                        MemberInvitationScreen()));
          }),
        ),
      ),
    );
  }
}
