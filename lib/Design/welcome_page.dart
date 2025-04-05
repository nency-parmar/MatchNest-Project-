import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:matrimony_application/Design/login_screen.dart';
import 'package:matrimony_application/Design/main_page.dart';

class WelcomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              filter: ImageFilter.blur(sigmaX: 0, sigmaY: 0), // Adjust blur intensity
              child: Container(
                color: Colors.black.withOpacity(0.2), // Overlay color for better contrast
              ),
            ),
          ),
          // Text Content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Welcome to Matrimony \n – Find the one \n your heart has been searching for!!",
                  style: GoogleFonts.abhayaLibre(
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
                ),// Spacing between texts
                // Text(
                //   "Discover meaningful connections and explore profiles tailored just for you...Let us help you find someone who truly complements your life.💖",
                //   style: GoogleFonts.harmattan(
                //     color: Color(0xFFFFCBA4), // Soft Peach
                //     fontSize: 30,
                //     fontWeight: FontWeight.w400,
                //     shadows: [
                //       Shadow(
                //         offset: Offset(2, 2),
                //         blurRadius: 5,
                //         color: Colors.black.withOpacity(0.5),
                //       ),
                //     ],
                //   ),
                //   textAlign: TextAlign.center,
                // ),
                SizedBox(height: 10),
                ElevatedButton(onPressed: (){
                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>LoginScreen()));
                },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFFFCBA4),
                      foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)
                    )
                  ),
                    child: Text(
                      'Begin Your Journey',
                      style: GoogleFonts.aBeeZee(
                        color: Colors.brown, // Soft Peach
                        fontSize: 25,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}