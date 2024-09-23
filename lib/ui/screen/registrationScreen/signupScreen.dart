import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:credixo/main.dart';
import 'package:credixo/ui/screen/dashboard/dashboardScreen.dart';
import 'package:credixo/ui/widgets/textFieldWidget.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Signupscreen extends StatefulWidget {
  final VoidCallback onClickedSignIn;

  const Signupscreen({Key? key, required this.onClickedSignIn})
      : super(key: key);

  @override
  State<Signupscreen> createState() => _SignupscreenState();
}

class _SignupscreenState extends State<Signupscreen> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final nameController = TextEditingController();
  final aadharNumberController = TextEditingController();
  final passwordController = TextEditingController();
  final phoneNumberController = TextEditingController();
  FirebaseAuth _auth = FirebaseAuth.instance;

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
                  Colors.black87,
                  Colors.black54,
                  Colors.grey[600]!,
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,  // Let the column take the minimum height required by its children
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/images/Credixo.png",
                    scale: 10,
                  ),
                  SizedBox(height: 20),  // Replace Spacer with a fixed size
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Hey,",
                      style: TextStyle(fontSize: 28, fontWeight: FontWeight.w600,color: Colors.white),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Sign Up",
                      style: TextStyle(fontSize: 28, fontWeight: FontWeight.w600,color: Colors.white),
                    ),
                  ),
                  SizedBox(height: 20),  // Replace Spacer with a fixed size
                  CustomTextField(
                    controller: aadharNumberController,
                    labelText: 'Aadhar Number',
                  ),
                  SizedBox(height: 10),
                  CustomTextField(
                    controller: nameController,
                    labelText: 'Name',
                  ),
                  SizedBox(height: 10),
                  CustomTextField(
                    controller: emailController,
                    labelText: 'Email',
                    validator: (email) =>
                    email != null && !EmailValidator.validate(email) ? 'Enter a valid email' : null,
                  ),
                  SizedBox(height: 10),
                  CustomTextField(
                    controller: phoneNumberController,
                    labelText: 'Mobile Number',
                  ),
                  SizedBox(height: 10),
                  CustomTextField(
                    controller: passwordController,
                    labelText: 'Password',
                    isPassword: true,
                    validator: (value) => value != null && value.length < 6 ? 'Enter minimum 6 Characters' : null,
                  ),
                  SizedBox(height: 20),  // Replace Spacer with a fixed size
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color( 0xFFFFE280),
                      foregroundColor: Colors.grey[800],
                      minimumSize: Size(MediaQuery.of(context).size.width * 0.95, 55),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 5,
                    ),
                    onPressed: signUp,
                    child: Text(
                      "Sign Up",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  SizedBox(height: 20),  // Replace Spacer with a fixed size
                  Text(
                    "---------------Or sign in with---------------",
                    style: TextStyle(fontSize: 15,color: Colors.white),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      buildSocialMediaIcon(signInWithGoogle,"assets/icons/google.png"),
                      SizedBox(width: 10),
                      buildSocialMediaIcon((){},"assets/icons/facebook.png"),
                      SizedBox(width: 10),
                      buildSocialMediaIcon((){},"assets/icons/microsoft.png"),
                    ],
                  ),
                  SizedBox(height: 20),
                  RichText(
                    text: TextSpan(
                      style: TextStyle(color: Colors.white),
                      text: 'Already Have an Account?  ',
                      children: [
                        TextSpan(
                          recognizer: TapGestureRecognizer()..onTap = widget.onClickedSignIn,
                          text: 'Log In',
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.10),
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

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in with Google and get the user
      UserCredential userCredential = await _auth.signInWithCredential(credential);
      User? user = userCredential.user;

      // Check if it's a new user
      if (userCredential.additionalUserInfo!.isNewUser) {
        // Save additional user information in Firestore
        await FirebaseFirestore.instance.collection('users').doc(user!.uid).set({
          'name': user.displayName,
          'email': user.email,
          'phone': user.phoneNumber ?? '',
        });
      }

      // Navigate to the Dashboard
      navigatorKey.currentState!.popUntil((route) => route.isFirst);
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const DashboardScreen())
      );
    } catch (e) {
      print("Exception caugth:- $e}");
      // Handle error
    }
  }


  Widget buildSocialMediaIcon(OnTap(),String imagePath) {
    return InkWell(
      onTap: OnTap,
      child: Container(
        height: 45,
        width: 45,
        padding: EdgeInsets.all(8), // Add padding to the container
        decoration: BoxDecoration(
          color:  Colors.grey[800],
          border: Border.all(color: Colors.white), // Add border
          borderRadius: BorderRadius.circular(8), // Optional: Add border radius
        ),
        child: Image.asset(imagePath),
      ),
    );
  }


  Future signUp() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(
        child: CircularProgressIndicator(),
      ),
    );

    try {
      // Create user with email and password
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      // Update the user's display name
      await userCredential.user!.updateDisplayName(nameController.text.trim());

      // Save additional user information in Firestore
      await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).set({
        'name': nameController.text.trim(),
        'email': emailController.text.trim(),
        'phone': phoneNumberController.text.trim(),
        'aadharNumber': aadharNumberController.text.trim(),
      });

      // Navigate to the first route
      navigatorKey.currentState!.popUntil((route) => route.isFirst);
    } on FirebaseAuthException catch (e) {
      print(e);
      // Handle error (e.g., show a message to the user)
    }
  }
}
