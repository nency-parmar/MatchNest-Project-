import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AboutUs extends StatefulWidget {
  const AboutUs({super.key});

  @override
  State<AboutUs> createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'About Us',
          style: TextStyle(
            color: Colors.white, // Ensures contrast
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF4E2A14), // Deep Coffee Brown
        elevation: 5,
        shadowColor: Colors.black45,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white), // Back button
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Stack(
        children: [
          // Background Image with Blur Effect
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/holding_hands_welcome_page.jpg"),
                fit: BoxFit.cover,
              ),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: Container(
                color: Colors.black.withOpacity(0.3), // Overlay color
              ),
            ),
          ),
          // Content Layout
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Logo/Avatar
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
                  SizedBox(height: 15),
                  // Matrimony Text
                  Text(
                    "MatchNest",
                    style: GoogleFonts.quicksand(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 1.2,
                    ),
                  ),
                  SizedBox(height: 30),
                  // Meet Our Team Section
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration
                      (
                      border: Border.all(color: Color(0xFF4E2A14), width: 2),
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.white.withOpacity(0.9),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.pinkAccent.withOpacity(0.2),
                          blurRadius: 10,
                          spreadRadius: 2,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Meet Our Team",
                          style: GoogleFonts.bebasNeue(
                            fontSize: 26,
                            color: Color(0xFFB76E79),
                          ),
                        ),
                        Divider(color: Colors.brown),
                        SizedBox(height: 8),
                        Text(
                          "Developed by\nNency Parmar (23010101193)\n\n"
                              "Mentored by\nProf. Mehul Bhundiya (Computer Engineering Department), "
                              "School of Computer Science\n\n"
                              "Explored by\nMatrimony, School Of Computer Science\n\n"
                              "Eulogized by\nDarshan University, Rajkot, Gujarat - INDIA",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.roboto(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  // About Us Section
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(color: Color(0xFF4E2A14), width: 2),
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.white.withOpacity(0.9),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.pinkAccent.withOpacity(0.2),
                          blurRadius: 10,
                          spreadRadius: 2,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "About Us",
                          style: GoogleFonts.bebasNeue(
                            fontSize: 26,
                            color: Color(0xFFB76E79),
                          ),
                        ),
                        Divider(color: Colors.brown),
                        SizedBox(height: 8),
                        Text(
                          "Welcome to MatchNest, where we believe that every love story deserves a perfect beginning. "
                              "Our platform is designed to connect hearts, foster meaningful relationships, and help individuals "
                              "find their ideal life partners in a secure and trusted environment.",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.roboto(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 12),
                        Text(
                          "✨ Our Vision",
                          style: GoogleFonts.roboto(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFB76E79),
                          ),
                        ),
                        Text(
                          "To create a seamless and joyful matchmaking experience, helping people find true companionship.",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.roboto(fontSize: 16, color: Colors.black87),
                        ),
                        SizedBox(height: 12),
                        Text(
                          "🎯 Our Mission",
                          style: GoogleFonts.roboto(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFB76E79),
                          ),
                        ),
                        Text(
                          "• Secure & trustworthy matchmaking\n"
                              "• Personalized partner recommendations\n"
                              "• Easy-to-use and feature-rich platform",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.roboto(fontSize: 16, color: Colors.black87),
                        ),
                      ],
                    ),
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