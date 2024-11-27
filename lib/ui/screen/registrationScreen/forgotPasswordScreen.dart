import 'package:credixo/ui/widgets/textFieldWidget.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../main.dart';

class Forgotpasswordscreen extends StatefulWidget {
  const Forgotpasswordscreen({super.key});

  @override
  State<Forgotpasswordscreen> createState() => _ForgotpasswordscreenState();
}

class _ForgotpasswordscreenState extends State<Forgotpasswordscreen> {
  final textController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  var verificationId = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8EAC9),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8EAC9),
        title: Row(
          children: [
            const SizedBox(width: 20),
            Image.asset(
              "assets/images/Credixo.png",
            ),
            const Spacer(),
          ],
        ),
      ),
      body: SingleChildScrollView(
        // Wrapping the content inside a SingleChildScrollView
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            // Minimize the size of the column based on its content
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 40), // Replaced Spacer with fixed height
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Forgot Password",
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
                ),
              ),
              const SizedBox(height: 40), // Replaced Spacer with fixed height

              CustomTextField(
                controller: textController,
                labelText: 'Email Address/Contact Number',
                validator: (email) =>
                    email != null && !EmailValidator.validate(email)
                        ? 'Enter a valid email or Mobile number'
                        : null,
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.brown,
                  foregroundColor: Colors.white,
                  minimumSize:
                      Size(MediaQuery.of(context).size.width * 0.95, 55),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 5,
                ),
                onPressed: resetPasword,
                child: const Text(
                  "Reset Password",
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future resetPasword() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
              child: CircularProgressIndicator(),
            ));
    try {
      if (EmailValidator.validate(textController.text)) {
        await _auth.sendPasswordResetEmail(email: textController.text.trim());
        navigatorKey.currentState!.popUntil((route) => route.isFirst);
      } else if (textController.text.length == 10) {
        await _auth.verifyPhoneNumber(
          phoneNumber: textController.text,
          verificationCompleted: (credentials) async {
            await _auth.signInWithCredential(credentials);
          },
          verificationFailed: (e) {
            print(e);
          },
          codeSent: (verificationId, resendToken) {
            this.verificationId = verificationId;
          },
          codeAutoRetrievalTimeout: (verificationId) {
            this.verificationId = verificationId;
          },
        );
      } else {
        print("Enter a valid email or phone number");
      }
    } on FirebaseAuthException catch (e) {
      print(e);
      navigatorKey.currentState!.pop();
    }
  }

  Future<bool> verifyOTP(String otp) async {
    var credentials = await _auth.signInWithCredential(
        PhoneAuthProvider.credential(
            verificationId: verificationId, smsCode: otp));
    return credentials.user != null ? true : false;
  }
}
