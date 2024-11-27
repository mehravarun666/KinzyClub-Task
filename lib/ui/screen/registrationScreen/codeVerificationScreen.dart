import 'dart:async';

import 'package:credixo/ui/screen/dashboard/dashboardScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Codeverificationscreen extends StatefulWidget {
  const Codeverificationscreen({super.key});

  @override
  State<Codeverificationscreen> createState() => _CodeverificationscreenState();
}

class _CodeverificationscreenState extends State<Codeverificationscreen> {
  bool isEmailVerified = false;
  bool canResedEmail = false;
  Timer? timer;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    if (!isEmailVerified) {
      sendVerificationEmail();

      timer = Timer.periodic(
          const Duration(seconds: 3), (_) => checkEmailVerified());
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  checkEmailVerified() async {
    await FirebaseAuth.instance.currentUser!.reload();
    setState(() {
      isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });

    if (isEmailVerified) timer?.cancel();
  }

  Future sendVerificationEmail() async {
    try {
      final user = FirebaseAuth.instance.currentUser!;
      await user.sendEmailVerification();

      setState(() => canResedEmail = false);
      await Future.delayed(const Duration(seconds: 5));
      setState(() => canResedEmail = true);
    } on Exception catch (e) {
      print(e);
      // TODO
    }
  }

  @override
  Widget build(BuildContext context) => isEmailVerified
      ? const DashboardScreen()
      : Scaffold(
          body: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.white54,
                      Colors.white60,
                      Colors.white70,
                    ],
                  ),
                ),
              ),
              SingleChildScrollView(
                child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            const SizedBox(width: 20),
                            Image.asset(
                              "assets/images/Credixo.png",
                            ),
                            const Spacer(),
                          ],
                        ),
                        const Text(
                            "A verification code has been send to your email",style: TextStyle(color: Colors.white
                        ),),
                        const SizedBox(
                          height: 20,
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white24,
                            foregroundColor: Colors.white,
                            minimumSize:
                                Size(MediaQuery.of(context).size.width * 0.95, 55),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 5,
                          ),
                          onPressed: canResedEmail ? sendVerificationEmail : null,
                          child: const Text(
                            "Resend Email",
                            style: TextStyle(fontSize: 20,color: Colors.white),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextButton(
                            onPressed: () => FirebaseAuth.instance.signOut,
                            child: const Text("Cancel"))
                      ],
                    )),
              ),
            ],
          ),
        );
}
