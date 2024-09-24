import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_note_app_hive/Core/Common/CustomElevatedButton/custom_elevated_button.dart';
import 'package:flutter_note_app_hive/Core/Common/CustomTextField/custom_text_field.dart';
import 'package:flutter_note_app_hive/Core/Common/space.dart';
import 'package:flutter_note_app_hive/Core/app_export.dart';

import '../../../Core/Theme/new_custom_text_style.dart';
import '../../Home/Screens/note_list_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _phoneController = TextEditingController();
  final _otpController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String _verificationId = '';
  bool _codeSent = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomTextField(
                controller: _phoneController, label: "Phone Number"),
            // TextField(
            //   controller: _phoneController,
            //   decoration: InputDecoration(labelText: 'Phone Number'),
            //   keyboardType: TextInputType.phone,
            // ),
            space(),
            if (_codeSent)
              CustomTextField(
                  keyboardType: TextInputType.number,
                  controller: _otpController,
                  label: "OTP"),

            space(),
            CustomElevatedButton(
                onPressed: _codeSent ? _verifyOTP : _sendOTP,
                buttonTextStyle: CustomPoppinsTextStyles.buttonText,
                text: _codeSent ? 'Verify OTP' : 'Send OTP',
                height: 50.v,
                width: SizeUtils.width * 0.4,
                // text: "Register",
                buttonStyle: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all<Color>(
                    appTheme.mainGreen,
                  ),
                  // Set background color to red
                  shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(10), // Set border radius to 24
                    ),
                  ),
                  // You can add more styling properties here, such as padding, elevation, etc.
                )),
            // ElevatedButton(
            //   onPressed: _codeSent ? _verifyOTP : _sendOTP,
            //   child: Text(_codeSent ? 'Verify OTP' : 'Send OTP'),
            // ),
          ],
        ),
      ),
    );
  }

  void _sendOTP() async {
    await _auth.verifyPhoneNumber(
      phoneNumber: "+91${_phoneController.text}",
      verificationCompleted: (PhoneAuthCredential credential) async {
        await _auth.signInWithCredential(credential);
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => NoteListScreen()),
        );
      },
      verificationFailed: (FirebaseAuthException e) {
        print(e.message);
        // Show error message to user
      },
      codeSent: (String verificationId, int? resendToken) {
        setState(() {
          _verificationId = verificationId;
          _codeSent = true;
        });
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        setState(() {
          _verificationId = verificationId;
        });
      },
    );
  }

  void _verifyOTP() async {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: _verificationId,
      smsCode: _otpController.text,
    );

    try {
      await _auth.signInWithCredential(credential);
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => NoteListScreen()),
      );
    } catch (e) {
      print(e);
      // Show error message to user
    }
  }
}
