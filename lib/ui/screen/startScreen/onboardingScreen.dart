import 'package:credixo/routes/AuthPage.dart';
import 'package:credixo/services/userServices.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

final List<OnBoard> demoData = [
  OnBoard(
    image: 'assets/lottie/onboard1.json',
    title: 'Welcome to Task Management App',
    description: 'Create and Arrange your Todos',
  ),
  OnBoard(
    image: 'assets/lottie/onboard2.json',
    title: 'Perfect for Every Board',
    description: 'Create boards and lists',
  ),
  OnBoard(
    image: 'assets/lottie/onboard3.json',
    title: 'Drag and Drop Features',
    description:
        "Drag tasks from one list to another!",
  ),
];

class Onboarding1 extends StatefulWidget {
  const Onboarding1({super.key});

  @override
  State<Onboarding1> createState() => _Onboarding1State();
}

class _Onboarding1State extends State<Onboarding1> {
  final userService = UserServices();
  late PageController _pageController;
  int _pageIndex = 0;
  bool _isLastPage = false;

  @override
  void initState() {
    _pageController = PageController(initialPage: 0);
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose(); // Dispose to avoid memory leaks
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() {
      _pageIndex = index;
      _isLastPage = index == demoData.length - 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
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
              children: [
                Row(
                  children: [
                    Image.asset(
                      "assets/images/Credixo.png",
                    ),
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: TextButton(
                        onPressed: () async {
                          if (_isLastPage) {
                            await userService.setOnboardingCompleted(true);
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const Authpage())); // Navigate to home or next screen
                          } else {
                            setState(() {
                              _pageIndex =
                                  demoData.length - 1; // Jump to last page
                              _pageController.animateToPage(_pageIndex,
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeIn);
                            });
                          }
                        },
                        child: Text(
                          _isLastPage ? "SIGN UP" : "SKIP",
                          style: const TextStyle(color: Color(0xFFFFD700)),
                        ),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: PageView.builder(
                    onPageChanged: _onPageChanged,
                    itemCount: demoData.length,
                    controller: _pageController,
                    itemBuilder: (context, index) => OnBoardContent(
                      title: demoData[index].title,
                      description: demoData[index].description,
                      image: demoData[index].image,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ...List.generate(
                          demoData.length,
                          (index) => Padding(
                            padding: const EdgeInsets.only(right: 4),
                            child: DotIndicator(
                              isActive: index == _pageIndex,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFE280),
                    foregroundColor: Colors.grey[800], // Text color
                    minimumSize: Size(MediaQuery.of(context).size.width * 0.95,
                        40), // Button width and height
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(12), // Rounded corners
                    ),
                    elevation: 5,
                  ),
                  onPressed: () async {
                    await userService.setOnboardingCompleted(true);
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const Authpage())); // Navigate to home or next screen
                  },
                  child: const Text("START MANAGING"),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Already have an account?",
                        style: TextStyle(color: Colors.white)),
                    TextButton(
                      onPressed: () async {
                        await userService.setOnboardingCompleted(true);
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const Authpage())); // Navigate to home or next screen
                      },
                      child: const Text("Sign In",
                          style: TextStyle(color: Color(0xFFFFD700))),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class OnBoardContent extends StatelessWidget {
  const OnBoardContent({
    super.key,
    required this.image,
    required this.title,
    required this.description,
  });

  final String image;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          flex: 5,
          child: Lottie.asset(image),
        ),
        const SizedBox(height: 20),
        Expanded(
          flex: 2,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: width * 0.06, // Responsive font size
                    fontFamily: "Cairo",
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  description,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: width * 0.04, // Responsive font size
                    fontFamily: "Cairo",
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class DotIndicator extends StatelessWidget {
  const DotIndicator({
    this.isActive = false,
    super.key,
  });

  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: 8,
      width: isActive ? 24 : 8,
      decoration: BoxDecoration(
        color: isActive ? Colors.grey : Colors.white,
        border: isActive ? null : Border.all(color: Colors.black),
        borderRadius: const BorderRadius.all(
          Radius.circular(12),
        ),
      ),
    );
  }
}

class OnBoard {
  final String image, title, description;

  OnBoard({
    required this.image,
    required this.title,
    required this.description,
  });
}
