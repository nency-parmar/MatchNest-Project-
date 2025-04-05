import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:matrimony_application/Design/about_us.dart';
import 'package:matrimony_application/Design/add_user_form.dart';
import 'package:matrimony_application/Design/favourite_page.dart';
import 'package:matrimony_application/Design/review_page.dart';
import 'package:matrimony_application/Design/user_list.dart';

class ContactUs extends StatefulWidget {
  const ContactUs({super.key});

  @override
  State<ContactUs> createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Contact Us',
          style: TextStyle(
            color: Colors.white, // Ensures contrast
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        // backgroundColor: Color.fromRGBO(60, 40, 31, 1), // Rich Chocolate Brown
        backgroundColor: Color(0xFF4E2A14),
        // backgroundColor: Color(0xFFFFE3E3),
        elevation: 5,
        shadowColor: Colors.black45,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white), // Back button
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
          // Main Content
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Contact Info Section
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(color: Color(0xFF708090), width: 2),
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
                          "Get in Touch",
                          style: GoogleFonts.bebasNeue(
                            fontSize: 26,
                            color: Color(0xFFB76E79),
                          ),
                        ),
                        Divider(color: Colors.brown),
                        SizedBox(height: 10),
                        // Email
                        ListTile(
                          leading: Icon(Icons.email, color: Color(0xFF3E2723)),
                          title: Text(
                            "info@match_nest.com",
                            style: GoogleFonts.roboto(
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        // Phone
                        ListTile(
                          leading: Icon(Icons.phone, color: Color(0xFF3E2723)),
                          title: Text(
                            "+91 98765 43210",
                            style: GoogleFonts.roboto(
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        // Website
                        ListTile(
                          leading: Icon(Icons.language, color: Color(0xFF3E2723)),
                          title: Text(
                            "www.darshan.ac.in",
                            style: GoogleFonts.roboto(
                              fontSize: 16,
                              color: Colors.blueAccent,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  // More Options Section
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(color: Color(0xFF708090), width: 2),
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
                          "More Options",
                          style: GoogleFonts.bebasNeue(
                            fontSize: 26,
                            color: Color(0xFFB76E79),
                          ),
                        ),
                        Divider(color: Colors.brown),
                        SizedBox(height: 10),
                        // Share App
                        ListTile(
                          leading: Icon(Icons.share, color: Color(0xFF3E2723)),
                          title: Text("Share App", style: GoogleFonts.roboto(fontSize: 16)),
                        ),
                        // More Apps
                        ListTile(
                          leading: Icon(Icons.apps, color: Color(0xFF3E2723)),
                          title: Text("More Apps", style: GoogleFonts.roboto(fontSize: 16)),
                        ),
                        // Rate Us
                        ListTile(
                          leading: Icon(Icons.star_rate, color: Color(0xFF3E2723)),
                          title: Text("Rate Us", style: GoogleFonts.roboto(fontSize: 16)),
                        ),
                        // Like Us on Facebook
                        ListTile(
                          leading: Icon(Icons.facebook, color: Color(0xFF3E2723)),
                          title: Text("Follow us on Facebook", style: GoogleFonts.roboto(fontSize: 16)),
                        ),
                        // Like Us on Instagram
                        ListTile(
                          leading: Icon(Icons.camera_alt, color: Color(0xFF3E2723)), // Alternative icon
                          title: Text("Follow us on Instagram", style: GoogleFonts.roboto(fontSize: 16)),
                        ),
                        // Check for Updates
                        ListTile(
                          leading: Icon(Icons.system_update, color: Color(0xFF3E2723)),
                          title: Text("Check for Updates", style: GoogleFonts.roboto(fontSize: 16)),
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