import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Map<String, String> userData = {};
  int? age;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String birthDateString = prefs.getString('birthDate') ?? 'N/A';
    setState(() {
      userData = {
        'User Name': prefs.getString('userName') ?? 'N/A',
        'Email': prefs.getString('email') ?? 'N/A',
        'Mobile Number': prefs.getString('mobileNumber') ?? 'N/A',
        'Birth Date': birthDateString,
        'Gender': prefs.getString('gender') ?? 'N/A',
        'City': prefs.getString('city') ?? 'N/A',
        'Religion': prefs.getString('religion') ?? 'N/A',
        'Qualification': prefs.getString('qualification') ?? 'N/A',
        'Occupation': prefs.getString('occupation') ?? 'N/A',
        'Hobbies': prefs.getString('hobbies') ?? 'N/A',
        'Password': prefs.getString('password') ?? 'N/A',
      };
      age = _calculateAge(birthDateString);
    });
  }
  int? _calculateAge(String birthDateString) {
    if (birthDateString == 'N/A') return null;
    try {
      DateTime birthDate = DateFormat('yyyy-MM-dd').parse(birthDateString);
      DateTime today = DateTime.now();
      int age = today.year - birthDate.year;
      if (today.month < birthDate.month || (today.month == birthDate.month && today.day < birthDate.day)) {
        age--;
      }
      return age;
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFB76E79), Color(0xFFF5DEB3)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text('About Me!!',style: TextStyle(fontSize: 30,color: Colors.black),),
              Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                elevation: 5,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: CircleAvatar(
                          radius: 80,
                          backgroundImage: AssetImage('assets/images/couple_rings.jpg'),
                        ),
                      ),
                      SizedBox(height: 20),
                      ...userData.entries.map((entry) => _buildProfileInfo(entry.key, entry.value)).toList(),
                      if (age != null) _buildProfileInfo('Age', age.toString()),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  bool _isPasswordVisible = false;
  Widget _buildProfileInfo(String label, String value) {
    bool isPasswordField = label.toLowerCase() == 'password';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120, // Fixed width for labels
            child: Text(
              label,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    isPasswordField && !_isPasswordVisible ? '********' : value,
                    style: TextStyle(fontSize: 16),
                    overflow: TextOverflow.visible,
                    softWrap: true,
                  ),
                ),
                if (isPasswordField)
                  IconButton(
                    icon: Icon(
                      _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}