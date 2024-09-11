import 'package:credixo/ui/screen/startScreen/onboardingScreen.dart';
import 'package:credixo/ui/widgets/circularAnimation.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();

    // Call the navigation function after 3 seconds
    Future.delayed(const Duration(seconds: 3), _navigateToNextScreen);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _navigateToNextScreen() async {
    // final userService = UserServices();
    //
    // bool onboardingCompleted = await userService.getOnboardingCompleted();
    // bool loggedIn = await userService.getLoggedIn();

    // if (!onboardingCompleted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Onboarding1()),
      );
    // } else if (!loggedIn) {
    //   Navigator.pushReplacement(
    //     context,
    //     MaterialPageRoute(builder: (context) => const Loginscreen()),
    //   );
    // } else {
    //   Navigator.pushReplacement(
    //     context,
    //     MaterialPageRoute(builder: (context) => const Dashboardscreen()),
    //   );
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(flex: 1),
            const Text(
              'YAAR LOAN',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const Spacer(),
            const Text(
              'Welcome to Yaar Loan App',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w400,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 5),
            const Text(
              'Credit Pay Your Friends, Colleagues',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w300,
                color: Colors.grey,
              ),
            ),
            const Spacer(),
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Text.rich(
                  TextSpan(
                    children: _buildAnimatedTextSpans(_controller.value),
                  ),
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w600,
                  ),
                );
              },
            ),
            const Spacer(),
            // Replace the red circle with the custom loading indicator
            const ExpandingCircleIndicator(),
            const Spacer(flex: 2),
            const Text(
              'App Version 1.0',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w300,
                color: Colors.grey,
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }

  List<TextSpan> _buildAnimatedTextSpans(double animationValue) {
    const String text = 'Yaara Loan';
    List<TextSpan> spans = [];

    for (int i = 0; i < text.length; i++) {
      double offset = sin(animationValue * 2 * pi + i / 2);
      spans.add(
        TextSpan(
          text: text[i],
          style: TextStyle(
            color: i.isOdd ? Colors.grey : Colors.orange,
            fontSize: 36 + 4 * offset,
          ),
        ),
      );
    }
    return spans;
  }
}