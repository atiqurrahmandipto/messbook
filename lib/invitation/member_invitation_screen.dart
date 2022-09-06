import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class MemberInvitationScreen extends StatefulWidget {
  const MemberInvitationScreen({Key? key}) : super(key: key);

  @override
  State<MemberInvitationScreen> createState() => _MemberInvitationScreenState();
}

class _MemberInvitationScreenState extends State<MemberInvitationScreen> {
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
            SizedBox(
              height: 32,
            ),
            Text(
              "Invite members",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 4),
            Text(
              "Ask members to scan the following QR code to enter join your mess",
              style: TextStyle(fontSize: 16, color: Color(0xff434A54)),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Container(
              width: MediaQuery.of(context).size.width - 48,
              height: MediaQuery.of(context).size.width - 48,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: QrImage(
                  data: FirebaseAuth.instance.currentUser?.uid ?? "ERROR",
                  size: 220,
                  version: QrVersions.auto,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
