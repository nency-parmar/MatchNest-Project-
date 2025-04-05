import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:matrimony_application/Design/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {

  // region Varibles
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  String? _selectedCity;
  String? _gender;
  String? _selectedReligion;
  String? _selectedQualification;
  String? _selectedOccupation;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  List<String> _hobbies = [];
  // region end

  void _toggleHobby(String hobby) {
    setState(() {
      _hobbies.contains(hobby) ? _hobbies.remove(hobby) : _hobbies.add(hobby);
    });
  }

  Widget _buildCheckbox(String hobby) {
    return Expanded(
      child: CheckboxListTile(
        title: Text(hobby),
        value: _hobbies.contains(hobby),
        onChanged: (bool? value) {
          _toggleHobby(hobby);
        },
        controlAffinity: ListTileControlAffinity.leading,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFF0F5),
      appBar: AppBar(
        title: Text(
          'Sign Up',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
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
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Enter Your Name",
                  labelStyle: TextStyle(color: Colors.black),
                ),
                style: TextStyle(color: Colors.black),
                textCapitalization: TextCapitalization.words,
                inputFormatters: [
                  FilteringTextInputFormatter.deny(RegExp(r'[0-9]'))
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please Enter UserName!!!";
                  } else if (value.length < 5) {
                    return "Username Must Be of 5 Characters.";
                  } else {
                    return null;
                  }
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: "Enter Your Email", border: OutlineInputBorder()),
                keyboardType: TextInputType.emailAddress,
                validator: (value) => (value == null || value.isEmpty) ? "Please enter your email" : null,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _mobileController,
                decoration: InputDecoration(labelText: "Mobile Number", border: OutlineInputBorder()),
                keyboardType: TextInputType.phone,
                maxLength: 10,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (value) => (value == null || value.isEmpty) ? "Please enter your mobile number" : null,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _dobController,
                readOnly: true,
                decoration: InputDecoration(labelText: "Date of Birth", border: OutlineInputBorder()),
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                  );
                  if (pickedDate != null) {
                    _dobController.text = DateFormat("dd/MM/yyyy").format(pickedDate);
                  }
                },
                validator: (value) => value!.isEmpty ? "Please select your DOB" : null,
              ),
              SizedBox(height: 16),
              Text("Gender", style: TextStyle(fontWeight: FontWeight.bold)),
              Row(
                children: [
                  Expanded(child: RadioListTile(title: Text("Male"), value: "Male", groupValue: _gender, onChanged: (value) => setState(() => _gender = value)) ),
                  Expanded(child: RadioListTile(title: Text("Female"), value: "Female", groupValue: _gender, onChanged: (value) => setState(() => _gender = value)) ),
                ],
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedCity,
                decoration: InputDecoration(
                  labelText: "City",
                  labelStyle: TextStyle(color: Colors.black),
                ),
                style: TextStyle(color: Colors.black),
                items: [
                  "Delhi",
                  "Mumbai",
                  "Bangalore",
                  "Morbi",
                  "Rajkot",
                  "Ahmedabad"
                ]
                    .map((city) =>
                    DropdownMenuItem(
                      value: city,
                      child: Text(
                          city, style: TextStyle(color: Colors.black)),
                    )
                )
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCity = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please select your city";
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              Text("Hobbies", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              Column(
                children: [
                  Row(children: [_buildCheckbox("Travelling"), _buildCheckbox("Reading Novels")]),
                  Row(children: [_buildCheckbox("Listening Music"), _buildCheckbox("Photography")]),
                  Row(children: [_buildCheckbox("Shopping"), _buildCheckbox("Handicraft")]),
                  Row(children: [_buildCheckbox("Writing"), _buildCheckbox("Designing")]),
                ],
              ),
              SizedBox(height: 16),
              // Religion
              DropdownButtonFormField<String>(
                value: _selectedReligion,
                decoration: InputDecoration(labelText: "Religion", border: OutlineInputBorder()),
                items: ["Hinduism", "Islam", "Christianity", "Sikhism", "Buddhism", "Jainism", "Others"]
                    .map((occupation) => DropdownMenuItem(value: occupation, child: Text(occupation)))
                    .toList(),
                onChanged: (value) => setState(() => _selectedReligion = value),
                validator: (value) => value == null ? "Please select your Occupation" : null,
              ),
              SizedBox(height: 16),
              // Occupation
              DropdownButtonFormField<String>(
                value: _selectedOccupation,
                decoration: InputDecoration(labelText: "Occupation", border: OutlineInputBorder()),
                items: ["Job", "Business", "Student", "Freelancer", "Self-Employed", "Retired", "Others"]
                    .map((occupation) => DropdownMenuItem(value: occupation, child: Text(occupation)))
                    .toList(),
                onChanged: (value) => setState(() => _selectedOccupation = value),
                validator: (value) => value == null ? "Please select your Occupation" : null,
              ),
              SizedBox(height: 16),
              // Qualification
              DropdownButtonFormField<String>(
                value: _selectedQualification,
                decoration: InputDecoration(labelText: "Qualification", border: OutlineInputBorder()),
                items: ["High School", "Undergraduate", "Postgraduate", "Doctorate","Others"]
                    .map((occupation) => DropdownMenuItem(value: occupation, child: Text(occupation)))
                    .toList(),
                onChanged: (value) => setState(() => _selectedQualification = value),
                validator: (value) => value == null ? "Please select your Occupation" : null,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  labelText: "Password",
                  border: OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                ),
                validator: (value) => (value == null || value.length < 6) ? "Password must be at least 6 characters" : null,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _confirmPasswordController,
                obscureText: _obscureConfirmPassword,
                decoration: InputDecoration(
                  labelText: "Confirm Password",
                  border: OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(_obscureConfirmPassword ? Icons.visibility_off : Icons.visibility),
                    onPressed: () {
                      setState(() {
                        _obscureConfirmPassword = !_obscureConfirmPassword;
                      });
                    },
                  ),
                ),
                validator: (value) => value != _passwordController.text ? "Passwords do not match" : null,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    SharedPreferences prefs = await SharedPreferences.getInstance();

                    await prefs.setString('userName', _nameController.text.trim());
                    await prefs.setString('password', _passwordController.text.trim());
                    await prefs.setString('email', _emailController.text.trim());
                    await prefs.setString('mobileNumber', _mobileController.text.trim());
                    await prefs.setString('birthDate', _dobController.text.trim());
                    await prefs.setString('gender', _gender ?? "",);
                    await prefs.setString('city', _selectedCity ?? "");
                    await prefs.setString('religion',  _selectedReligion ?? "");
                    await prefs.setString('qualification', _selectedQualification ?? "");
                    await prefs.setString('occupation', _selectedOccupation ?? "");
                    await prefs.setString('hobbies', _hobbies.join(", "));

                    // Navigate to Login Page after storing user data
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please fill all fields")));
                  }
                },
                child: Text("Sign Up",style: TextStyle(color: Colors.white),),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF4E2A14),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}