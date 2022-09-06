import 'package:flutter/material.dart';
import 'package:mess_manager/database.dart';
import 'package:mess_manager/home/home.dart';
import 'package:mess_manager/invitation/member_invitation_screen.dart';
import 'package:mess_manager/invitation/qr_scan_screen.dart';
import 'package:mess_manager/ui_provider.dart';

class RoleSelectionScreen extends StatefulWidget {
  final String uid;

  const RoleSelectionScreen({Key? key, required this.uid}) : super(key: key);

  @override
  State<RoleSelectionScreen> createState() => _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends State<RoleSelectionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffEAF2FF),
      appBar: AppBar(
        title: Text(""),
        backgroundColor: Color(0xffEAF2FF),
        elevation: 0,
      ),
      body: Center(
        child: Column(
          children: [
            Text(
              "Select your role",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(
              "Select if you are a mess member or a mess manager",
              style: TextStyle(fontSize: 16, color: Color(0xff434A54)),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 32),
            Padding(
              padding: const EdgeInsets.all(6.0),
              child: UIProvider.actionBtn(context, text: 'Manager', onTap: () {
                createMess();
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) =>
                            MemberInvitationScreen()));
              }),
            ),
            Padding(
              padding: const EdgeInsets.all(6.0),
              child: UIProvider.actionBtn(context, text: 'Member', onTap: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => QRScannerWidget()));
              }),
            ),
          ],
        ),
      ),
    );
  }

  void createMess() async {
    await DatabaseService(uid: widget.uid)
        .createMess("VIKINGS", 22, 51, 2211);
    //now join as member
    await DatabaseService(uid: widget.uid).joinMess(widget.uid);
  }
}
