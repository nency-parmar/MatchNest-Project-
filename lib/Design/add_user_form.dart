import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:matrimony_application/Design/utils/user.dart';
// import 'package:matrimony_application/Database/user_db_helper.dart';
import 'package:matrimony_application/API/api_service.dart';

class AddUserForm extends StatefulWidget {
  final bool isEditing;
  final AppUser? user;
  final Map<String, dynamic>? userData;

  const AddUserForm({super.key, this.isEditing = false, this.user, this.userData});

  @override
  State<AddUserForm> createState() => _AddUserState();
}

class _AddUserState extends State<AddUserForm> {

  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  final ApiService apiService = ApiService();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  bool _obscurePassword = true;
  final List<String> _selectedHobbies = [];
  String? _gender;
  String? _selectedreligions;
  String? _selectedQualification;
  String? _selectedOccupation;
  String? _selectedCity;

  @override
  void initState() {
    super.initState();
    if (widget.user != null) {
      _nameController.text = widget.user!.name;
      _emailController.text = widget.user!.email;
      _mobileController.text = widget.user!.num;
      _dobController.text = widget.user!.dob ?? "";

      if (_dobController.text.isNotEmpty) {
        _calculateAge(_dobController.text);
      }

      _passwordController.text = widget.user!.pass;
      _selectedCity = widget.user!.city;
      _gender = widget.user!.gender;
      _selectedreligions = widget.user!.religion;
      _selectedQualification = widget.user!.qualification;
      _selectedOccupation = widget.user!.occupation;

      _selectedHobbies.addAll(widget.user!.hobbies?.split(', ') ?? []);
    }
  }
  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _mobileController.dispose();
    _dobController.dispose();
    _ageController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Widget _buildCheckbox(String hobby) {
    return Expanded(
      child: CheckboxListTile(
        title: Text(
          hobby,
          style: TextStyle(color: Colors.black),
        ),
        value: _selectedHobbies.contains(hobby),
        onChanged: (bool? value) {
          setState(() {
            if (value == true) {
              _selectedHobbies.add(hobby);
            } else {
              _selectedHobbies.remove(hobby);
            }
          });
        },
        activeColor: Colors.grey,
        checkColor: Colors.white,
        controlAffinity: ListTileControlAffinity.leading,
      ),
    );
  }
  void _calculateAge(String dob) {
    try {
      DateTime birthDate = DateFormat("dd/MM/yyyy").parse(dob);
      DateTime today = DateTime.now();
      int age = today.year - birthDate.year;
      if (today.month < birthDate.month || (today.month == birthDate.month && today.day < birthDate.day)) {
        age--;
      }
      setState(() {
        _ageController.text = age.toString();
      });
    } catch (e) {
      print("Error parsing date: $e");
    }
  }
  Future<void> _addUser() async {
    if (!_key.currentState!.validate()) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    AppUser newUser = AppUser(
      id: widget.user?.id, // ✅ Keep existing ID for updates
      name: _nameController.text,
      email: _emailController.text,
      num: _mobileController.text,
      age: int.tryParse(_ageController.text) ?? 0,
      dob: _dobController.text,
      city: _selectedCity ?? "",
      hobbies: _selectedHobbies.join(", "),
      gender: _gender ?? "",
      religion: _selectedreligions ?? "",
      qualification: _selectedQualification ?? "",
      occupation: _selectedOccupation ?? "",
      pass: _passwordController.text,
      isFavorite: widget.user?.isFavorite ?? false,
    );

    try {
      if (widget.isEditing) {
        await apiService.updateUser(newUser); // ✅ Update User
        Navigator.pop(context); // ✅ Close loading dialog
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "User Updated Successfully!!",
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      } else {
        await apiService.addUser(newUser);
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "User Added Successfully!!",
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      }

      Navigator.pop(context, newUser); // ✅ Close form and return new user
    } catch (e) {
      Navigator.pop(context); // ✅ Close loading dialog
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error: ${e.toString()}"),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Register User',
          style: TextStyle(
            color: Colors.black,
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
        elevation: 5,
        shadowColor: Colors.black45,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Color(0xFFFFF0F5),
            ),
          ),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _key,
                child: Column(
                  children: [
                    // User Name
                    _buildFormField(
                      controller: _nameController,
                      labelText: "Enter Your Name",
                      icon: Icons.person,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please Enter UserName!!!";
                        } else if (value.length < 5) {
                          return "Username Must Be of 5 Characters.";
                        }
                        return null;
                      },
                      // textCapitalization: TextCapitalization.words,
                      inputFormatters: [
                        FilteringTextInputFormatter.deny(RegExp(r'[0-9]'))
                      ],
                    ),
                    SizedBox(height: 20),
                    // Email
                    _buildFormField(
                      controller: _emailController,
                      labelText: "Enter Your Email Address",
                      icon: Icons.email,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter your email address";
                        } else if (!RegExp(
                            r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}")
                            .hasMatch(value)) {
                          return "Please enter a valid email address";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    // Mobile Number
                    _buildFormField(
                      controller: _mobileController,
                      labelText: "Mobile Number",
                      icon: Icons.phone,
                      keyboardType: TextInputType.phone,
                      maxLength: 10,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter your mobile number";
                        } else if (!RegExp(r"^\d{10}$").hasMatch(value)) {
                          return "Please enter a valid 10-digit mobile number";
                        }
                        return null;
                      },
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                      ],
                    ),
                    SizedBox(height: 20),
                    // Date of Birth
                    _buildFormField(
                      controller: _dobController,
                      labelText: "Date of Birth",
                      icon: Icons.calendar_month_outlined,
                      readOnly: true,
                      onTap: () async {
                        DateTime? selectedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1900),
                          lastDate: DateTime.now(),
                        );
                        if (selectedDate != null) {
                          String formattedDate = DateFormat("dd/MM/yyyy").format(selectedDate);
                          _dobController.text = formattedDate;
                          _calculateAge(formattedDate);
                        }
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please select your date of birth";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    // City
                    _buildDropdownFormField(
                      value: _selectedCity,
                      labelText: "City",
                      icon: Icons.location_city,
                      items: ["Delhi", "Mumbai", "Bangalore", "Morbi", "Rajkot", "Ahmedabad"],
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
                    SizedBox(height: 20),
                    // Gender
                    _buildGenderField(),
                    SizedBox(height: 20),
                    // Hobbies
                    _buildHobbiesField(),
                    SizedBox(height: 20),
                    // Religion
                    _buildDropdownFormField(
                      value: _selectedreligions,
                      labelText: "Religion",
                      icon: Icons.people,
                      items: [
                        "Hinduism",
                        "Islam (Muslim)",
                        "Christianity",
                        "Sikhism",
                        "Buddhism",
                        "Jainism",
                        "Zoroastrianism (Parsi)"
                      ],
                      onChanged: (value) {
                        setState(() {
                          _selectedreligions = value!;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please select your Religion";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    // Highest Qualification
                    _buildDropdownFormField(
                      value: _selectedQualification,
                      labelText: "Highest Qualification",
                      icon: Icons.school,
                      items: [
                        "High School",
                        "Undergraduate",
                        "Postgraduate",
                        "Doctorate",
                        "Others"
                      ],
                      onChanged: (value) {
                        setState(() {
                          _selectedQualification = value!;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please select your Highest Qualification";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    // Occupation
                    _buildDropdownFormField(
                      value: _selectedOccupation,
                      labelText: "Occupation",
                      icon: Icons.work,
                      items: [
                        "Job",
                        "Business",
                        "Student",
                        "Freelancer",
                        "Self-Employed",
                        "Retired",
                        "Others"
                      ],
                      onChanged: (value) {
                        setState(() {
                          _selectedOccupation = value;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please select your Occupation";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    // Password
                    _buildFormField(
                      controller: _passwordController,
                      labelText: "Password",
                      icon: Icons.lock,
                      obscureText: _obscurePassword,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword ? Icons.visibility_off : Icons.visibility,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter a password";
                        } else if (value.length < 6) {
                          return "Password must be at least 6 characters long";
                        } else if (!RegExp(r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{6,}$').hasMatch(value)) {
                          return "Password must contain at least one letter, one number, and one special character.";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    // Submit Button
                    Center(
                      child: ElevatedButton(
                        onPressed: _addUser,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF4E2A14),
                          padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                        ),
                        child: Text(
                          widget.isEditing ? "Update" : "Submit",
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormField({
    required TextEditingController controller,
    required String labelText,
    required IconData icon,
    TextInputType? keyboardType,
    bool obscureText = false,
    bool readOnly = false,
    int? maxLength,
    Widget? suffixIcon,
    Function()? onTap,
    String? Function(String?)? validator,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xFFFADADD), // Light Pink Background
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Color(0xFFB76E79), width: 1), // Rose Border
        ),
        padding: EdgeInsets.symmetric(horizontal: 12),
        child: TextFormField(
          controller: controller,
          decoration: InputDecoration(
            labelText: labelText,
            labelStyle: TextStyle(color: Color(0xFF8B3A3A)), // Deep Rose Label
            prefixIcon: Icon(icon, color: Color(0xFF8B3A3A)), // Icon with Deep Rose
            suffixIcon: suffixIcon,
            border: InputBorder.none,
          ),
          style: TextStyle(color: Colors.black),
          keyboardType: keyboardType,
          obscureText: obscureText,
          readOnly: readOnly,
          maxLength: maxLength,
          onTap: onTap,
          validator: validator,
        ),
      ),
    );
  }
  Widget _buildDropdownFormField({
    required String? value,
    required String labelText,
    required IconData icon,
    required List<String> items,
    required Function(String?) onChanged,
    required String? Function(String?)? validator,
  }) {
    // ✅ Ensure unique values
    List<String> uniqueItems = items.toSet().toList();

    // ✅ Ensure the value exists in items, otherwise set to null
    String? dropdownValue = (value != null && uniqueItems.contains(value)) ? value : null;

    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xFFFADADD), // Light Pink Background
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Color(0xFFB76E79), width: 1), // Rose Border
        ),
        padding: EdgeInsets.symmetric(horizontal: 12),
        child: DropdownButtonFormField<String>(
          value: dropdownValue,
          decoration: InputDecoration(
            labelText: labelText,
            labelStyle: TextStyle(color: Color(0xFF8B3A3A)), // Deep Rose Label
            prefixIcon: Icon(icon, color: Color(0xFF8B3A3A)), // Icon with Deep Rose
            border: InputBorder.none,
          ),
          style: TextStyle(color: Colors.black),
          items: uniqueItems.map((item) => DropdownMenuItem(
            value: item,
            child: Text(item),
          )).toList(),
          onChanged: onChanged,
          validator: validator,
        ),
      ),
    );
  }
  Widget _buildGenderField() {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xFFFADADD), // Light Pink Background
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Color(0xFFB76E79), width: 1), // Rose Border
        ),
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Gender",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF8B3A3A)),
            ),
            Row(
              children: [
                Expanded(
                  child: RadioListTile<String>(
                    title: Text("Male", style: TextStyle(color: Colors.black)),
                    value: "Male",
                    groupValue: _gender,
                    onChanged: (value) {
                      setState(() => _gender = value);
                    },
                    activeColor: Color(0xFF8B3A3A), // Deep Rose
                  ),
                ),
                Expanded(
                  child: RadioListTile<String>(
                    title: Text("Female", style: TextStyle(color: Colors.black)),
                    value: "Female",
                    groupValue: _gender,
                    onChanged: (value) {
                      setState(() => _gender = value);
                    },
                    activeColor: Color(0xFF8B3A3A), // Deep Rose
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildHobbiesField() {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xFFFADADD), // Light Pink Background
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Color(0xFFB76E79), width: 1), // Rose Border
        ),
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Hobbies",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF8B3A3A)),
            ),
            Column(
              children: [
                Row(
                  children: [
                    _buildCheckbox("Travelling"),
                    _buildCheckbox("Reading Novels"),
                  ],
                ),
                Row(
                  children: [
                    _buildCheckbox("Listening Music"),
                    _buildCheckbox("Photography"),
                  ],
                ),
                Row(
                  children: [
                    _buildCheckbox("Shopping"),
                    _buildCheckbox("Handicraft"),
                  ],
                ),
                Row(
                  children: [
                    _buildCheckbox("Writing"),
                    _buildCheckbox("Designing"),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}