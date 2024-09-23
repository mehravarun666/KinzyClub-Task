import 'package:credixo/ui/screen/registrationScreen/codeVerificationScreen.dart';
import 'package:credixo/ui/screen/registrationScreen/loginScreen.dart';
import 'package:credixo/ui/screen/registrationScreen/signupScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Authpage extends StatefulWidget {
  const Authpage({super.key});

  @override
  State<Authpage> createState() => _AuthpageState();
}

class _AuthpageState extends State<Authpage> {
  bool isLogin = true;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // Check if the user is logged in
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        else if (snapshot.hasData) {
          // User is logged in, show dashboard
          return const Codeverificationscreen();
          // return const Dashboardscreen();
        }
        else {
          // User is not logged in, show login/signup page
          return isLogin
              ? Loginscreen(onClickedSignUp: toggle)
              : Signupscreen(onClickedSignIn: toggle);
        }
      },
    );
  }

  void toggle() => setState(() {
        isLogin = !isLogin;
      });
}
