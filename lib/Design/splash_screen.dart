import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:matrimony_application/Design/login_screen.dart';
import 'package:matrimony_application/Design/main_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double _opacity = 0.0;

  @override
  void initState() {
    super.initState();
    _startFadeIn();
    _navigateToNextScreen();
  }

  void _startFadeIn() {
    Future.delayed(Duration(milliseconds: 500), () {
      setState(() {
        _opacity = 1.0;
      });
    });
  }

  Future<void> _navigateToNextScreen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    String userName = prefs.getString('userName') ?? "User";

    await Future.delayed(Duration(seconds: 3)); // Delay before navigating

    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => isLoggedIn ? MainPage(userName: userName) : LoginScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/holding_hands_welcome_page.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Blur Effect
          Container(
            color: Colors.black.withOpacity(0.4),
          ),
          // Centered Logo & Text with Fade-in Effect
          Center(
            child: AnimatedOpacity(
              duration: Duration(seconds: 2),
              opacity: _opacity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.pinkAccent[100],
                    child: ClipOval(
                      child: Image.asset(
                        "assets/images/couple_rings.jpg",
                        fit: BoxFit.cover,
                        width: 120,
                        height: 120,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Welcome to MatchNest \n – Find the one \n your heart has been searching for!!",
                    style: GoogleFonts.marcellus(
                      color: Color(0xFFFFCBA4), // Soft Peach
                      fontSize: 50,
                      fontWeight: FontWeight.w400,
                      shadows: [
                        Shadow(
                          offset: Offset(2, 2),
                          blurRadius: 5,
                          color: Colors.black.withOpacity(0.5),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 10), // Spacing between texts
                  Text(
                    "Where Love Begins and Journeys Blossom!!💖",
                    style: GoogleFonts.harmattan(
                      color: Color(0xFFFFCBA4), // Soft Peach
                      fontSize: 30,
                      fontWeight: FontWeight.w400,
                      shadows: [
                        Shadow(
                          offset: Offset(2, 2),
                          blurRadius: 5,
                          color: Colors.black.withOpacity(0.5),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}