import 'package:flutter/material.dart';
import 'package:mess_manager/invitation/member_invitation_screen.dart';

class MembersListScreen extends StatefulWidget {
  const MembersListScreen({Key? key}) : super(key: key);

  @override
  State<MembersListScreen> createState() => _MembersListScreenState();
}

class _MembersListScreenState extends State<MembersListScreen> {
  List<String> _members = [
    'Saeedus Salehin',
    'Atiqur Rahman Dipto',
    'Mehedi Hasan Saikat',
    'Ragib Monsur'
  ];

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Color(0xffEAF2FF),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 48),
          Padding(
            padding: EdgeInsets.all(12.0),
            child: Text(
              'Mess members',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w400),
            ),
          ),
          SizedBox(height: 24),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              physics: BouncingScrollPhysics(),
              itemCount: _members.length,
              scrollDirection: Axis.vertical,
              itemBuilder: (context, position) {
                return _memberCard(position);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Ink(
              height: 60,
              width: MediaQuery.of(context).size.width - 24,
              decoration: BoxDecoration(
                color: Colors.greenAccent.withOpacity(0.3),
                borderRadius: BorderRadius.circular(20),
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) =>
                              MemberInvitationScreen(false)));
                },
                child: Row(
                  children: const [
                    SizedBox(width: 18),
                    Icon(Icons.add),
                    SizedBox(width: 8),
                    Text(
                      'Add member',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _memberCard(int position) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Ink(
        height: 65,
        width: MediaQuery.of(context).size.width - 24,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            //todo: go to individual profile
          },
          child: Row(
            children: [
              SizedBox(width: 18),
              CircleAvatar(
                backgroundColor: Colors.black12,
                minRadius: 18,
                maxRadius: 18,
                child: Center(
                  child: Icon(
                    Icons.person,
                    color: Colors.black38,
                  ),
                ),
              ),
              SizedBox(width: 8),
              Text(
                _members.elementAt(position),
                style: TextStyle(fontSize: 18),
              ),
              Spacer(),
              SizedBox(
                  width: 30,
                  height: 30,
                  child: Icon(Icons.more_vert)),
              SizedBox(width: 12),
            ],
          ),
        ),
      ),
    );
  }
}
