import 'package:flutter/material.dart';
import 'package:matrimony_application/Design/add_user_form.dart';
import 'package:matrimony_application/Design/user_details.dart';
import 'package:matrimony_application/Design/utils/user.dart';
// import 'package:matrimony_application/Database/user_db_helper.dart' as db_helper;
import 'package:matrimony_application/API/api_service.dart'; // Import API Service

class UserList extends StatefulWidget {
  @override
  _UserListState createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  // db_helper.UserDBHelper dbHelper = db_helper.UserDBHelper.instance;
  // List<AppUser> userList = []; // ✅ Changed from `User` to `AppUser`
  ApiService apiService = ApiService();
  List<AppUser> userList = [];

  TextEditingController _searchController = TextEditingController();
  String searchQuery = "";
  bool isReversed = false;
  bool isSortedAZ = false;

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  bool isLoading = true;

  Future<void> _loadUsers() async {
    setState(() {
      isLoading = true; // Show loading indicator
    });

    try {
      List<AppUser> users = await apiService.getUser();
      if (mounted) {
        setState(() {
          userList = users;
          _applySorting();
        });
      }
    } catch (e) {
      debugPrint("Error loading users: $e");
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false; // Hide loading indicator
        });
      }
    }
  }

  List<AppUser> get filteredUsers {
    if (searchQuery.isEmpty) {
      return userList;
    }
    return userList.where((user) =>
    (user.name?.toLowerCase() ?? "").contains(searchQuery.toLowerCase()) ||
        (user.email?.toLowerCase() ?? "").contains(searchQuery.toLowerCase()) ||
        (user.city?.toLowerCase() ?? "").contains(searchQuery.toLowerCase()) ||
        user.age.toString().contains(searchQuery)).toList();
  }

  void addUser() async {
    final newUser = await Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => AddUserForm(isEditing: false)),
    );
    if (newUser != null) {
      await apiService.addUser(newUser);
      _loadUsers();
    }
  }

  void toggleFavorite(BuildContext context, AppUser user) async {
    try {
      // Toggle favorite status locally
      setState(() {
        user.isFavorite = !user.isFavorite;
      });

      // Update user in API
      await apiService.updateUser(user);

      // Show SnackBar message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            user.isFavorite
                ? "User Added to Favourite!!"
                : "User Removed from Favourite!!",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          backgroundColor: user.isFavorite ? Colors.green : Colors.red,
          duration: Duration(seconds: 2),
        ),
      );

      // Reload user list after API update
      _loadUsers();
    } catch (e) {
      print("Error updating favorite status: $e");
    }
  }

  void _confirmDelete(BuildContext context, String id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        bool isDeleting = false; // Track deletion state

        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(
                "Delete User",
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
              ),
              content: isDeleting
                  ? Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                    strokeWidth: 4,
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Deleting user...",
                    style: TextStyle(color: Colors.black54, fontSize: 16),
                  ),
                ],
              )
                  : Text("Are you sure you want to delete this user?"),
              actions: [
                TextButton(
                  child: Text("Cancel", style: TextStyle(color: Colors.black)),
                  onPressed: isDeleting ? null : () => Navigator.of(context).pop(),
                ),
                TextButton(
                  child: Text("Delete", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                  onPressed: isDeleting
                      ? null
                      : () async {
                    setState(() => isDeleting = true); // Show loader

                    await apiService.deleteUser(id);

                    if (mounted) {
                      Navigator.of(context).pop(); // Close dialog
                      _loadUsers(); // Refresh list
                    }
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _applySorting() {
    setState(() {
      if (isSortedAZ) {
        userList.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
      } else {
        userList.sort((a, b) => b.name.toLowerCase().compareTo(a.name.toLowerCase()));
      }

      if (isReversed) {
        userList = userList.reversed.toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'User List',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              setState(() {
                if (value == 'Reverse') {
                  isReversed = !isReversed;  // ✅ Toggle reverse order
                } else if (value == 'A-Z') {
                  isSortedAZ = true; // ✅ Corrected A-Z sorting flag
                } else if (value == 'Z-A') {
                  isSortedAZ = false; // ✅ Corrected Z-A sorting flag
                }
                _applySorting();
              });
            },
            itemBuilder: (context) => [
              PopupMenuItem(value: 'Reverse', child: Text(isReversed ? 'Normal Order' : 'Reverse Order')),
              PopupMenuItem(value: 'A-Z', child: Text('Sort A-Z')),
              PopupMenuItem(value: 'Z-A', child: Text('Sort Z-A')),
            ],
          )
        ],
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFB76E79), Color(0xFFF5DEB3)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ), // Deep Coffee Brown
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
              color: Color(0xFFFFF0F5), // Light Pinkish Background
            ),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(10),
                  // Search Bar
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: "Search Users By Name , E-mail , Age , City",
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    onChanged: (query) {
                      setState(() {
                        searchQuery = query;
                      });
                    },
                  ),
                ),
                Expanded(
                  child: isLoading
                      ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFB76E79)), // Matching App Theme
                          strokeWidth: 5, // Thick for a premium look
                        ),
                        SizedBox(height: 20),
                        Text(
                          "Fetching Users...",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF4E2A14)),
                        ),
                      ],
                    ),
                  )
                      : filteredUsers.isEmpty
                      ? Center(
                    child: Text(
                      "No Users Found",
                      style: TextStyle(fontSize: 18, color: Colors.black),
                    ),
                  )
                      : ListView.builder(
                    itemCount: filteredUsers.length,
                    itemBuilder: (context, index) {
                      var userData = filteredUsers[index];
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => UserDetails(user: userData.toMap()),
                            ),
                          );
                        },
                        child: Card(
                          margin: EdgeInsets.all(8),
                          color: Colors.black26,
                          child: Padding(
                            padding: EdgeInsets.all(10),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  backgroundColor: Color(0xFF4E2A14),
                                  radius: 50,
                                  child: Text(
                                    userData.name[0], // ✅ Correct usage
                                    style: TextStyle(fontSize: 50, color: Colors.white),
                                  ),
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${userData.name}',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                      SizedBox(height: 5),
                                      Row(
                                        children: [
                                          Icon(Icons.location_city, color: Colors.white),
                                          SizedBox(width: 5),
                                          Text('${userData.city}', style: TextStyle(color: Colors.white)),
                                        ],
                                      ),
                                      SizedBox(height: 5),
                                      Row(
                                        children: [
                                          Icon(Icons.calendar_month_outlined, color: Colors.white),
                                          SizedBox(width: 5),
                                          Text('${userData.age}', style: TextStyle(color: Colors.white)), // ✅ Display calculated age
                                        ],
                                      ),
                                      SizedBox(height: 5),
                                      Row(
                                        children: [
                                          Icon(Icons.email, color: Colors.white),
                                          SizedBox(width: 5),
                                          Flexible(
                                            child: Text(
                                              '${userData.email}',
                                              style: TextStyle(color: Colors.white),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                              softWrap: false,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                // Edit, Favorite, and Delete Buttons
                                Column(
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.edit, color: Colors.blue),
                                      onPressed: () async {
                                        final updatedUser = await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => AddUserForm(
                                              isEditing: true,
                                              user: userData, // ✅ Send user data to edit
                                            ),
                                          ),
                                        );

                                        if (updatedUser != null) {
                                          _loadUsers(); // ✅ Refresh user list after update
                                        }
                                      },
                                    ),
                                    IconButton(
                                      icon: Icon(
                                        userData.isFavorite ? Icons.favorite : Icons.favorite_border,
                                        color: userData.isFavorite ? Colors.red : Colors.white,
                                      ),
                                      onPressed: () {
                                        toggleFavorite(context, userData);
                                      },
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.delete, color: Colors.red),
                                      onPressed: () => _confirmDelete(context, userData.id.toString()), // ✅ Convert int? to String
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}