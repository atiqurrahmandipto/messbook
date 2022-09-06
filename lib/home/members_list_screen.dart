import 'package:flutter/material.dart';

class MembersListScreen extends StatefulWidget {
  const MembersListScreen({Key? key}) : super(key: key);

  @override
  State<MembersListScreen> createState() => _MembersListScreenState();
}

class _MembersListScreenState extends State<MembersListScreen> {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Color(0xffEAF2FF),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          SizedBox(height: 48),
          Padding(
            padding: EdgeInsets.all(12.0),
            child: Text(
              'Mess members',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w400),
            ),
          )
        ],
      ),
    );
  }
}
