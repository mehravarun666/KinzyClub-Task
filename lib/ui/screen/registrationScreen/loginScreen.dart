import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:credixo/main.dart';
import 'package:credixo/ui/screen/dashboard/dashboardScreen.dart';
import 'package:credixo/ui/screen/registrationScreen/forgotPasswordScreen.dart';
import 'package:credixo/ui/widgets/textFieldWidget.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Loginscreen extends StatefulWidget {
  final VoidCallback onClickedSignUp;

  const Loginscreen({super.key, required this.onClickedSignUp});

  @override
  State<Loginscreen> createState() => _LoginscreenState();
}

class _LoginscreenState extends State<Loginscreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final phoneNumberController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            // Wrapping the content inside a SingleChildScrollView
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                // Minimize the size of the column based on its content
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                      height: 50),
                  Image.asset(
                    "assets/images/Credixo.png",
                  ),
                  const SizedBox(
                      height: 30), // Replaced Spacer with fixed height
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Hey,",
                      style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w600,
                          color: Colors.white),
                    ),
                  ),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Login Now",
                      style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w600,
                          color: Colors.white),
                    ),
                  ),
                  const SizedBox(
                      height: 40), // Replaced Spacer with fixed height

                  CustomTextField(
                    controller: emailController,
                    labelText: 'User or Email',
                    validator: (email) =>
                        email != null && !EmailValidator.validate(email)
                            ? 'Enter a valid email'
                            : null,
                  ),
                  const SizedBox(height: 10),
                  CustomTextField(
                    controller: phoneNumberController,
                    labelText: 'Mobile Number',
                  ),
                  const SizedBox(height: 10),
                  CustomTextField(
                    controller: passwordController,
                    labelText: 'Password',
                    isPassword: true,
                    validator: (value) => value != null && value.length < 6
                        ? 'Enter minimum 6 Characters'
                        : null,
                  ),
                  const SizedBox(height: 20),
                  Align(
                    alignment: Alignment.topRight,
                    child: GestureDetector(
                        onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) =>
                                    const Forgotpasswordscreen())),
                        child: const Text(
                          "Forgot Password?",
                          style: TextStyle(color: Colors.white),
                        )),
                  ),
                  const SizedBox(
                      height: 20), // Replaced Spacer with fixed height

                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFFE280),
                      foregroundColor: Colors.grey[800],
                      minimumSize:
                          Size(MediaQuery.of(context).size.width * 0.95, 55),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 5,
                    ),
                    onPressed: signIn,
                    child: const Text(
                      "Sign In",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  const SizedBox(
                      height: 40), // Replaced Spacer with fixed height

                  const Text(
                    "---------------Or sign in with---------------",
                    style: TextStyle(fontSize: 15, color: Colors.white),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      buildSocialMediaIcon(
                          signInWithGoogle, "assets/icons/google.png"),
                      const SizedBox(width: 10),
                      buildSocialMediaIcon(() {}, "assets/icons/facebook.png"),
                      const SizedBox(width: 10),
                      buildSocialMediaIcon(() {}, "assets/icons/microsoft.png"),
                    ],
                  ),
                  const SizedBox(height: 20),
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(color: Colors.white),
                      text: 'If you are new,  ',
                      children: [
                        TextSpan(
                          recognizer: TapGestureRecognizer()
                            ..onTap = widget.onClickedSignUp,
                          text: 'Create Now',
                          style: const TextStyle(
                            decoration: TextDecoration.underline,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.15),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        // The user canceled the sign-in
        return;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in with Google and get the user
      UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      User? user = userCredential.user;

      // Check if it's a new user
      if (userCredential.additionalUserInfo!.isNewUser) {
        // Save additional user information in Firestore
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user!.uid)
            .set({
          'name': user.displayName,
          'email': user.email,
          'phone': user.phoneNumber ?? '',
        });
      }

      // Navigate to the Dashboard
      navigatorKey.currentState!.popUntil((route) => route.isFirst);
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const DashboardScreen()));
    } catch (e) {
      print("Exception caugth:- $e}");
      // Handle error
    }
  }

  Widget buildSocialMediaIcon(Function() OnTap, String imagePath) {
    return InkWell(
      onTap: OnTap,
      child: Container(
        height: 45,
        width: 45,
        padding: const EdgeInsets.all(8), // Add padding to the container
        decoration: BoxDecoration(
          color: Colors.grey[800],
          border: Border.all(color: Colors.white), // Add border
          borderRadius: BorderRadius.circular(8), // Optional: Add border radius
        ),
        child: Image.asset(imagePath),
      ),
    );
  }

  Future signIn() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
              child: CircularProgressIndicator(),
            ));
    try {
      await _auth.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim());
      navigatorKey.currentState!.popUntil((route) => route.isFirst);
    } on FirebaseAuthException catch (e) {
      print(e);
      navigatorKey.currentState!.pop();
    }
  }
}
