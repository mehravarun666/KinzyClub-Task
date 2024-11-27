import 'package:credixo/services/userServices.dart';
import 'package:credixo/ui/screen/dashboard/dashboardScreen.dart';
import 'package:credixo/ui/screen/startScreen/onboardingScreen.dart';
import 'package:credixo/routes/AuthPage.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), _navigateToNextScreen);
  }

  Future<void> _navigateToNextScreen() async {
    final userService = UserServices();

    bool onboardingCompleted = await userService.getOnboardingCompleted();
    bool loggedIn = await userService.getLoggedIn();

    if (!mounted) return;

    if (!onboardingCompleted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Onboarding1()),
      );
    } else if (!loggedIn) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Authpage()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const DashboardScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[700],
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
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // const Spacer(), // Remove or replace this spacer if not needed
              // Add specific spacing if needed
              Image.asset("assets/images/Credixo.png"),
              const SizedBox(height: 10),
              const Text(
                "Welcome to Plan IT",
                style: TextStyle(
                    fontFamily: "Cairo", fontSize: 22, color: Colors.white),
              ),
              const Text(
                "Create, Update and Manage Tasks",
                style: TextStyle(
                    fontFamily: "Cairo", fontSize: 16, color: Colors.white),
              ),
              const SizedBox(height: 10),
              // Add a smaller gap if needed
              Lottie.asset('assets/lottie/loading.json'),
              // const SizedBox(height: 20),
              // Add specific spacing instead of Spacer
              const Align(
                alignment: Alignment.bottomRight,
                child: Text(
                  "App Version 1.0\t\t\t",
                  style: TextStyle(
                      fontFamily: "Cairo", fontSize: 14, color: Colors.white),
                ),
              ),
              const SizedBox(height: 20),
            ],
          )
        ],
      ),
    );
  }
}
