import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:mess_manager/authentication/role_selection_screen.dart';
import 'package:mess_manager/ui_provider.dart';
import 'package:rxdart/rxdart.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController phoneController = TextEditingController();
  TextEditingController otpController = TextEditingController();

  final BehaviorSubject<bool> _loaderBehavior = BehaviorSubject();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool otpVisibility = false;
  String _phoneNumber = "";
  String _verificationId = "";
  List<String> _smsCode = [];

  @override
  void dispose() {
    super.dispose();
    _loaderBehavior.close();
  }

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
              Visibility(
                visible: !otpVisibility,
                child: Column(
                  children: [
                    SvgPicture.asset("assets/images/ic_logo.svg"),
                    Text(
                      'MessBook',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 36),

                    IntlPhoneField(
                      decoration: InputDecoration(
                        labelText: 'Phone Number',
                        border: OutlineInputBorder(
                          borderSide: BorderSide(),
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                        ),
                      ),
                      initialCountryCode: 'BD',
                      onChanged: (phone) {
                        _phoneNumber = phone.completeNumber.toString();
                        debugPrint(_phoneNumber);
                      },
                    ),

                    // UIProvider.textField(context, text: "Enter your phone number"),
                    SizedBox(height: 12),
                    _loaderBehavior.valueOrNull ?? false
                        ? SizedBox(
                            height: 40,
                            child: CircularProgressIndicator(),
                          )
                        : UIProvider.actionBtn(context, text: "Continue",
                            onTap: () {
                            _loaderBehavior.sink.add(true);
                            setState(() {});
                            _verifyPhoneNumber();
                          }),
                  ],
                ),
              ),
              Visibility(
                visible: otpVisibility,
                child: Column(
                  children: [
                    SizedBox(
                      height: 48,
                    ),
                    Text(
                      'Verification',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Enter your OTP here",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black38,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 28,
                    ),
                    Container(
                      padding: EdgeInsets.all(28),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _textFieldOTP(first: true, last: false),
                              _textFieldOTP(first: false, last: false),
                              _textFieldOTP(first: false, last: false),
                              _textFieldOTP(first: false, last: false),
                              _textFieldOTP(first: false, last: false),
                              _textFieldOTP(first: false, last: true),
                            ],
                          ),
                          SizedBox(
                            height: 22,
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                _signInWithPhoneNumber();
                              },
                              style: ButtonStyle(
                                foregroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.white),
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.purple),
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(24.0),
                                  ),
                                ),
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(14.0),
                                child: Text(
                                  'Sign in',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 18,
                    ),
                    Text(
                      "Didn't receive any code?",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black38,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 18,
                    ),
                    Text(
                      "Request new OTP",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.purple,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _textFieldOTP({required bool first, last}) {
    return SizedBox(
      height: 50,
      child: AspectRatio(
        aspectRatio: 1,
        child: TextField(
          autofocus: true,
          onChanged: (value) {
            _smsCode.add(value);
            if (value.length == 1 && last == false) {
              FocusScope.of(context).nextFocus();
            }
            if (value.isEmpty && first == false) {
              FocusScope.of(context).previousFocus();
            }
          },
          showCursor: false,
          readOnly: false,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          keyboardType: TextInputType.number,
          maxLength: 1,
          decoration: InputDecoration(
            counter: Offstage(),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 2, color: Colors.black12),
                borderRadius: BorderRadius.circular(12)),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 2, color: Colors.purple),
                borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ),
    );
  }

  void _verifyPhoneNumber() async {
    try {
      await _auth.verifyPhoneNumber(
          phoneNumber: _phoneNumber,
          timeout: const Duration(seconds: 60),
          verificationCompleted:
              (PhoneAuthCredential phoneAuthCredential) async {
            //Callback for when the user has already previously signed in with this phone number on this device
            await _auth.signInWithCredential(phoneAuthCredential);
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => RoleSelectionScreen(
                        uid: _auth.currentUser?.uid ?? "")));

            debugPrint(
                "Phone number automatically verified and user signed in. !!!!!");
          },
          verificationFailed: (FirebaseAuthException authException) {
            //Listens for errors with verification, such as too many attempts
            _loaderBehavior.sink.add(false);
          },
          codeSent: (String verificationId, int? forceResendingToken) {
            //Callback for when the code is sent
            _verificationId = verificationId;
            otpVisibility = true;
            setState(() {});
          },
          codeAutoRetrievalTimeout: (String verificationId) {
            _verificationId = verificationId;
          });
    } catch (e) {
      debugPrint("Failed to Verify Phone Number: $e");
    }
  }

  void _signInWithPhoneNumber() async {
    debugPrint(_smsCode.join());
    PhoneAuthCredential _phoneAuthCredential = PhoneAuthProvider.credential(
        verificationId: _verificationId, smsCode: _smsCode.join());

    try {
      await _auth
          .signInWithCredential(_phoneAuthCredential)
          .then((UserCredential authRes) {
        User? _firebaseUser = authRes.user;
        debugPrint(_firebaseUser.toString());

        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => RoleSelectionScreen(
                      uid: _firebaseUser?.uid ?? "",
                    )));
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
