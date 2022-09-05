import 'package:flutter/material.dart';

class UIProvider {
  static Widget textField(BuildContext context,
      {required String text, bool split = false}) {
    return SizedBox(
      height: 55,
      width: split
          ? MediaQuery.of(context).size.width / 2.2
          : MediaQuery.of(context).size.width,
      child: TextField(
        decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            filled: true,
            hintStyle: TextStyle(color: Colors.grey[500]),
            hintText: text,
            fillColor: Colors.white),
      ),
    );
  }

  static Widget actionBtn(BuildContext context, {required String text, required Function() onTap}) {
    return Ink(
      color: Color(0xff1572A1),
      height: 50,
      width: MediaQuery.of(context).size.width,
      child: InkWell(
        onTap: onTap,
        child: Center(
          child: Text(
            text,
            style: TextStyle(
                fontWeight: FontWeight.w500, color: Colors.white, fontSize: 18),
          ),
        ),
      ),
    );
  }
}
