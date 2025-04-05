import 'package:flutter/material.dart';
// import 'package:matrimony_application/Database/user_db_helper.dart';
import 'package:matrimony_application/API/api_service.dart';

class UserDetails extends StatefulWidget {
  final Map<String, dynamic> user;

  const UserDetails({super.key, required this.user});

  @override
  State<UserDetails> createState() => _UserDetailsState();
}

class _UserDetailsState extends State<UserDetails> {
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _fetchFavoriteStatus();
  }

  // Fetch favorite status from DB
  void _fetchFavoriteStatus() async {
    bool isFav = await ApiService().isUserFavorite(widget.user['id']);
    setState(() {
      _isFavorite = isFav;
    });
  }

  // Function to toggle favorite status
  void _toggleFavorite() async {
    setState(() {
      _isFavorite = !_isFavorite;
    });

    await ApiService().toggleFavorite(widget.user['id'], _isFavorite);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isFavorite ? "Added to Favorites!" : "Removed from Favorites!",
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: _isFavorite ? Colors.green : Colors.red,
        duration: const Duration(seconds: 2),
      ),
    );

    // Notify previous screen to update the UI
    Navigator.pop(context, _isFavorite);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'User Details',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF4E2A14),
        elevation: 5,
        shadowColor: Colors.black45,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(
              _isFavorite ? Icons.favorite : Icons.favorite_border,
              color: _isFavorite ? Colors.red : Colors.white,
              size: 30,
            ),
            onPressed: _toggleFavorite,
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        color: const Color(0xFFFFF0F5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // User Profile Picture
            CircleAvatar(
              backgroundColor: const Color(0xFF4E2A14),
              radius: 50,
              child: Text(
                widget.user['name'][0],
                style: const TextStyle(fontSize: 50, color: Colors.white),
              ),
            ),
            const SizedBox(height: 20),
            // User Name
            Text(
              widget.user['name'] ?? "Unknown",
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            // Email
            Text(
              widget.user['email'],
              style: const TextStyle(fontSize: 16, color: Colors.black54),
            ),
            const SizedBox(height: 25),
            // User Details
            Expanded(
              child: ListView(
                children: [
                  _buildDetailCard(Icons.location_city, "City", widget.user['city']),
                  _buildDetailCard(Icons.transgender, "Gender", widget.user['gender']),
                  _buildDetailCard(Icons.star, "Hobbies", widget.user['hobbies'] ?? "Not specified"),
                  _buildDetailCard(Icons.phone, "Phone", widget.user['num'] ?? "N/A"),
                  _buildDetailCard(Icons.calendar_month_outlined, "Age", widget.user['age']?.toString() ?? "Unknown"),
                  _buildDetailCard(Icons.lock, "Password", "********"),
                  _buildDetailCard(Icons.account_circle, "Religion", widget.user['religion']),
                  _buildDetailCard(Icons.school, "Highest Qualification", widget.user['qualification']),
                  _buildDetailCard(Icons.work, "Occupation", widget.user['occupation']),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailCard(IconData icon, String title, String value) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
      elevation: 3,
      color: Colors.black26,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(icon, color: Colors.white70, size: 30),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    value,
                    style: const TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}