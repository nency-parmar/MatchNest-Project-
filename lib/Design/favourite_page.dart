import 'package:flutter/material.dart';
import 'package:matrimony_application/API/api_service.dart';
import 'package:matrimony_application/Design/user_details.dart';
import 'package:matrimony_application/Design/utils/user.dart';

class UserFavoritesPage extends StatefulWidget {
  @override
  _UserFavoritesPageState createState() => _UserFavoritesPageState();
}

class _UserFavoritesPageState extends State<UserFavoritesPage> {
  final apiService = ApiService(); // ✅ Use API service
  List<AppUser> userList = [];
  TextEditingController _searchController = TextEditingController();
  String searchQuery = "";
  bool isLoading = true; // ✅ Track loading state

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  // Fetch favorite users from API with loading state
  Future<void> _loadUsers() async {
    try {
      setState(() => isLoading = true); // ✅ Start loading
      List<AppUser> favoriteUsers = await apiService.getFavoriteUsers();
      setState(() {
        userList = favoriteUsers.isNotEmpty ? favoriteUsers : []; // ✅ Ensure it's not null
        isLoading = false; // ✅ Stop loading
      });
    } catch (e) {
      print("Error fetching favorite users: $e");
      setState(() => isLoading = false); // ✅ Stop loading on error
    }
  }

  // Toggle favorite using API and show SnackBar
  void toggleFavorite(BuildContext context, AppUser user) async {
    try {
      bool newFavoriteStatus = !user.isFavorite;

      AppUser updatedUser = AppUser(
        id: user.id,
        name: user.name,
        email: user.email,
        num: user.num,
        age: user.age,
        dob: user.dob,
        city: user.city,
        hobbies: user.hobbies,
        gender: user.gender,
        religion: user.religion,
        qualification: user.qualification,
        occupation: user.occupation,
        pass: user.pass,
        isFavorite: newFavoriteStatus, // ✅ Updated status
      );

      await apiService.updateUser(updatedUser);

      setState(() {
        if (!newFavoriteStatus) {
          userList.removeWhere((u) => u.id == user.id);
        } else {
          user.isFavorite = newFavoriteStatus;
        }
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            newFavoriteStatus
                ? "User Added to Favourites!"
                : "User Removed from Favourites!",
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          backgroundColor: newFavoriteStatus ? Colors.green : Colors.red,
          duration: const Duration(seconds: 2),
        ),
      );

      if (!newFavoriteStatus) {
        // ✅ Refresh the list after removing from favorites
        setState(() {
          userList = userList.where((u) => u.isFavorite).toList();
        });
      }
    } catch (e) {
      print("Error updating favorite status: $e");
    }
  }

  // Filter favorite users based on search query
  List<AppUser> get filteredFavoriteUsers {
    if (searchQuery.isEmpty) {
      return userList;
    }
    return userList.where((user) =>
    (user.name?.toLowerCase() ?? "").contains(searchQuery.toLowerCase()) ||
        (user.email?.toLowerCase() ?? "").contains(searchQuery.toLowerCase()) ||
        (user.city?.toLowerCase() ?? "").contains(searchQuery.toLowerCase()) ||
        user.age.toString().contains(searchQuery)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Favourite Users',
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
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              color: Color(0xFFFFF0F5),
            ),
          ),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: "Search Favorite Users By You Name , E-mail , City , Age!!!",
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
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
                    ? Center( // ✅ Show loading indicator while fetching data
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFB76E79)), // ✅ Match theme
                        strokeWidth: 5, // ✅ Thicker stroke for a premium look
                      ),
                      SizedBox(height: 20),
                      Text(
                        "Fetching Favorite Users...",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF4E2A14),
                        ),
                      ),
                    ],
                  ),
                )
                    : filteredFavoriteUsers.isEmpty
                    ? const Center(
                  child: Text(
                    "No favorite users found!",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                )
                    : ListView.builder(
                  itemCount: filteredFavoriteUsers.length,
                  itemBuilder: (context, index) {
                    var user = filteredFavoriteUsers[index];
                    return Card(
                      margin: const EdgeInsets.all(8),
                      color: Colors.black26,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: const Color(0xFF4E2A14),
                              radius: 50,
                              child: Text(
                                user.name[0],
                                style: const TextStyle(fontSize: 50, color: Colors.white),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: ListTile(
                                title: Text(
                                  user.name,
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        const Icon(Icons.location_city, color: Colors.white),
                                        const SizedBox(width: 5),
                                        Text(user.city ?? "Unknown City",
                                            style: const TextStyle(color: Colors.white)),
                                      ],
                                    ),
                                    const SizedBox(height: 5),
                                    Row(
                                      children: [
                                        const Icon(Icons.calendar_month_outlined, color: Colors.white),
                                        const SizedBox(width: 5),
                                        Text('${user.age}',
                                            style: const TextStyle(color: Colors.white)),
                                      ],
                                    ),
                                    const SizedBox(height: 5),
                                    Row(
                                      children: [
                                        const Icon(Icons.email, color: Colors.white),
                                        const SizedBox(width: 5),
                                        Flexible(
                                          child: Text(
                                            user.email,
                                            style: const TextStyle(color: Colors.white),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                onTap: () async {
                                  bool? updatedFavorite = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => UserDetails(user: user.toMap()),
                                    ),
                                  );

                                  if (updatedFavorite != null) {
                                    _loadUsers(); // Reload the favorite users list
                                  }
                                },
                              ),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                IconButton(
                                  icon: Icon(
                                    user.isFavorite ? Icons.favorite : Icons.favorite_border,
                                    color: user.isFavorite ? Colors.red : Colors.white,
                                  ),
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: Text(user.isFavorite ? "Remove from Favorites" : "Add to Favorites"),
                                        content: Text(user.isFavorite
                                            ? "Are you sure you want to remove this user from your favorites?"
                                            : "Do you want to add this user to favorites?"),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context); // ✅ Close dialog
                                            },
                                            child: const Text("Cancel"),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context); // ✅ Close dialog before toggling
                                              toggleFavorite(context, user);
                                            },
                                            child: const Text("Yes"),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}