import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:matrimony_application/Design/about_us.dart';
import 'package:matrimony_application/Design/add_user_form.dart';
import 'package:matrimony_application/Design/contact_us.dart';
import 'package:matrimony_application/Design/favourite_page.dart';
import 'package:matrimony_application/Design/profile_page.dart';
import 'package:matrimony_application/Design/review_page.dart';
import 'package:matrimony_application/Design/user_list.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math' as math;

import 'login_screen.dart'; // ✅ Import LoginScreen for navigation

class MainPage extends StatefulWidget {
  final String userName; // ✅ Add this

  const MainPage({Key? key, required this.userName}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final GlobalKey<ScaffoldState> _appKey = GlobalKey<ScaffoldState>();

  Future<void> _logoutUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // ✅ Clears all user data, including `isLoggedIn`

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
          (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _appKey,
      drawer: Drawer(
        child: Container(
          color: Color(0xFFFFF0F5),
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFFB76E79), Color(0xFFF5DEB3)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundImage: AssetImage("assets/images/couple_rings.jpg"),
                    ),
                    SizedBox(height: 10),
                    Text(
                      widget.userName,
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                  ],
                ),
              ),
              _buildDrawerItem(Icons.account_circle, "View Profile", () => _navigateTo(ProfilePage())),
              _buildDrawerItem(Icons.info, "About Us", () => _navigateTo(AboutUs())),
              _buildDrawerItem(Icons.phone, "Contact Us", () => _navigateTo(ContactUs())),
              _buildDrawerItem(Icons.comment, "Your Review", () => _navigateTo(ReviewPage())),
              Divider(),
              ListTile(
                leading: IconButton(
                  icon: Icon(
                    Icons.logout,
                    color: Color(0xFF4E2A14), // Ensures visibility
                    size: 30,
                  ),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text("Log Out?"),
                          content: Text("Are you sure you want to log out?"),
                          actions: [
                            TextButton(
                              child: Text("Cancel"),
                              onPressed: () {
                                Navigator.of(context).pop(); // Close dialog
                              },
                            ),
                            TextButton(
                              child: Text("Log Out", style: TextStyle(color: Colors.red)),
                              onPressed: () {
                                Navigator.of(context).pop(); // Close dialog
                                _logoutUser(); // ✅ Call logout function
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
                title: Text('Log Out?'),
                onTap: () {showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text("Log Out?"),
                      content: Text("Are you sure you want to log out?"),
                      actions: [
                        TextButton(
                          child: Text("Cancel"),
                          onPressed: () {
                            Navigator.of(context).pop(); // Close dialog
                          },
                        ),
                        TextButton(
                          child: Text("Log Out", style: TextStyle(color: Colors.red)),
                          onPressed: () {
                            Navigator.of(context).pop(); // Close dialog
                            _logoutUser(); // ✅ Call logout function
                          },
                        ),
                      ],
                    );
                  },
                );},
              ),
            ],
          ),
        ),
      ),
      // appBar: AppBar(
      //   title: Text('Matrimonial Application'),
      //   flexibleSpace: Container(
      //     decoration: BoxDecoration(
      //       gradient: LinearGradient(
      //         colors: [Color(0xFFB76E79), Color(0xFFF5DEB3)], // Gradient Colors
      //         begin: Alignment.topLeft,
      //         end: Alignment.bottomRight,
      //       ),
      //     ),
      //   ),
      //   backgroundColor: Colors.transparent,
      //   elevation: 0,
      //   actions: [
      //     IconButton(
      //       icon: Icon(
      //         Icons.logout,
      //         color: Colors.black, // Ensures visibility
      //         size: 30,
      //       ),
      //       onPressed: () {
      //         showDialog(
      //           context: context,
      //           builder: (BuildContext context) {
      //             return AlertDialog(
      //               title: Text("Log Out?"),
      //               content: Text("Are you sure you want to log out?"),
      //               actions: [
      //                 TextButton(
      //                   child: Text("Cancel"),
      //                   onPressed: () {
      //                     Navigator.of(context).pop(); // Close dialog
      //                   },
      //                 ),
      //                 TextButton(
      //                   child: Text("Log Out", style: TextStyle(color: Colors.red)),
      //                   onPressed: () {
      //                     Navigator.of(context).pop(); // Close dialog
      //                     _logoutUser(); // ✅ Call logout function
      //                   },
      //                 ),
      //               ],
      //             );
      //           },
      //         );
      //       },
      //     ),
      //   ],
      // ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Color(0xFFFFF0F5), // Soft Pinkish Background
            ),
          ),
           // Wave On The Top
           ClipPath(
            clipper: WaveClipper(),
            child: Container(
              height: 240,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFB76E79), Color(0xFFF5DEB3)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
          ),
          // Text On Clipath
          Positioned(
            top: 50,
            left: 3,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(Icons.menu, size: 28, color: Color(0xFF3E2723)),
                  onPressed: () => _appKey.currentState?.openDrawer(),
                ),
                SizedBox(width: 10),
                Text(
                  "MatchNest",
                  style: GoogleFonts.quicksand(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF3E2723),
                    letterSpacing: 1.2,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 100,
            left: 05, // Adjusted for better alignment
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child: CircleAvatar(
                        backgroundColor: Color(0xFF4E2A14),
                        radius: 45,
                        child: Text(
                          widget.userName.isNotEmpty ? widget.userName[0].toUpperCase() : "?",
                          style: TextStyle(fontSize: 30, color: Colors.white),
                        ),
                      ),
                    ),
                    SizedBox(width: 15,),
                    Text(
                      "Hello, \n${widget.userName}! \nReady to Find Your Soulmate?",
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black87),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            top: 60,
            right: 05, // Adjusted for better alignment
            child: CircleAvatar(
              backgroundColor: Color(0xFF4E2A14),
              radius: 20,
              child: Container(
                width: 120, // Slightly larger than image for border
                height: 120,
                padding: const EdgeInsets.all(2),
                child: ClipOval(
                  child: Image.asset(
                    "assets/images/couple_rings.jpg",
                    width: 20,
                    height: 20,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
          // Main UI
          Positioned(
            top: 280,
            left: 30,
            child: Padding(
              padding: const EdgeInsets.all(9.0),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    /// **Row 1**
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        menuButton(Icons.group_outlined, "User List", () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => UserList()),
                          );
                        }),
                        SizedBox(width: 50),
                        menuButton(Icons.group_add_sharp, "Add User", () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => AddUserForm()),
                          );
                        }),
                      ],
                    ),
                    SizedBox(height: 30),
                    /// **Row 2**
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        menuButton(Icons.favorite_rounded, "Favourite \nUser", () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => UserFavoritesPage()),
                          );
                        }),
                        SizedBox(width: 50),
                        menuButton(Icons.account_circle, "My Profile", () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ProfilePage()),
                          );
                        }),
                      ],
                    ),
                    SizedBox(height: 30),
                    /// **Row 3**
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.center,
                    //   children: [
                    //     menuButton(Icons.info, "About Us", () {
                    //       Navigator.push(
                    //         context,
                    //         MaterialPageRoute(builder: (context) => AboutUs()),
                    //       );
                    //     }),
                    //     SizedBox(width: 50),
                    //     menuButton(Icons.phone, "Contact Us", () {
                    //       Navigator.push(
                    //         context,
                    //         MaterialPageRoute(builder: (context) => ContactUs()),
                    //       );
                    //     }),
                    //   ],
                    // ),
                  ],
                ),
              ),
            ),
          ),
          // Bottom Wave
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Transform(
              alignment: Alignment.center,
              transform: Matrix4.rotationX(math.pi), // Flip the wave upside down
              child: ClipPath(
                clipper: WaveClipper(),
                child: Container(
                  height: 100,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFFF5DEB3), Color(0xFFB76E79)],
                      begin: Alignment.bottomRight,
                      end: Alignment.bottomLeft,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  //Reusable idget For Buttons
  Widget menuButton(IconData icon, String text, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xFFFFE3E3), // Soft Ivory Background
          border: Border.all(color: Color(0xFFD2B48C)), // Muted Gold Border
          borderRadius: BorderRadius.circular(50), // Adjusted for better proportions
        ),
        height: 125, // Reduced height
        width: 125,  // Reduced width
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: Color(0xFF4E2A14),
              size: 40, // Smaller icon
            ),
            SizedBox(height: 5), // Adds a small gap
            Text(
              text,
              style: TextStyle(fontSize: 14, color: Color(0xFF5D4037)), // Smaller text
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildDrawerItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Color(0xFF4E2A14)),
      title: Text(title, style: TextStyle(fontSize: 16, color: Color(0xFF5D4037))),
      onTap: onTap,
    );
  }

  void _navigateTo(Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }
}

// Wave Clipper Widget
class WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 30);

    var firstControlPoint = Offset(size.width / 4, size.height);
    var firstEndPoint = Offset(size.width / 2, size.height - 30);
    path.quadraticBezierTo(
      firstControlPoint.dx, firstControlPoint.dy, firstEndPoint.dx, firstEndPoint.dy,
    );

    var secondControlPoint = Offset(size.width * 3 / 4, size.height - 60);
    var secondEndPoint = Offset(size.width, size.height - 30);
    path.quadraticBezierTo(
      secondControlPoint.dx, secondControlPoint.dy, secondEndPoint.dx, secondEndPoint.dy,
    );

    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}