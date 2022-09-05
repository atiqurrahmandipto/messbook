import 'package:flutter/material.dart';

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
            ),
            SizedBox(height: 16),
            Text('Or'),
            SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 55,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(8),
                          topLeft: Radius.circular(8))),
                  width: MediaQuery.of(context).size.width / 2.25,
                  child: Center(
                      child: Text(
                    "1122xYz",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  )),
                ),
                Container(
                  height: 55,
                  decoration: BoxDecoration(
                      color: Color(0xff1572A1),
                      borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(8),
                          topRight: Radius.circular(8))),
                  width: MediaQuery.of(context).size.width / 2.25,
                  child: Center(
                    child: Text("Invite member",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.white)),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Text(
              "Skip",
              style:
                  TextStyle(fontSize: 16, decoration: TextDecoration.underline),
            )
          ],
        ),
      ),
    );
  }
}
