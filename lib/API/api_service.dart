import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:matrimony_application/Design/utils/user.dart';

class ApiService {
  String baseUrl = 'https://67d9230a00348dd3e2a9b8cd.mockapi.io/MatchNest_Users';

  Future<List<AppUser>> getUser() async {
    try {
      var res = await http.get(Uri.parse(baseUrl));

      if (res.statusCode == 200) {
        List<dynamic> data = jsonDecode(res.body);
        return data.map((e) => AppUser.fromMap(e)).toList();
      } else {
        throw Exception("Failed to load users");
      }
    } catch (e) {
      print("Error fetching users: $e");
      return [];
    }
  }

  Future<void> addUser(AppUser user) async {
    try {
      var res = await http.post(
        Uri.parse(baseUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(user.toMap()),
      );

      if (res.statusCode != 201) {
        throw Exception("Failed to add user");
      }
    } catch (e) {
      print("Error adding user: $e");
    }
  }

  Future<void> deleteUser(String id) async {
    try {
      var res = await http.delete(Uri.parse("$baseUrl/$id"));

      if (res.statusCode != 200) {
        throw Exception("Failed to delete user");
      }
    } catch (e) {
      print("Error deleting user: $e");
    }
  }

  Future<void> updateUser(AppUser user) async {
    try {
      var res = await http.put(
        Uri.parse("$baseUrl/${user.id}"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(user.toMap()), // ✅ Convert to JSON
      );

      if (res.statusCode != 200) {
        throw Exception("Failed to update user");
      }
    } catch (e) {
      print("Error updating user: $e");
    }
  }

  Future<List<AppUser>> getFavoriteUsers() async {
    try {
      var res = await http.get(Uri.parse("$baseUrl?isFavorite=true"));

      if (res.statusCode == 200) {
        List<dynamic> data = jsonDecode(res.body);
        return data.map((e) => AppUser.fromMap(e)).toList();
      } else {
        throw Exception("Failed to load favorite users");
      }
    } catch (e) {
      print("Error fetching favorite users: $e");
      return [];
    }
  }

  Future<bool> isUserFavorite(String userId) async {
    try {
      var res = await http.get(Uri.parse("$baseUrl/$userId"));

      if (res.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(res.body);
        return data['isFavorite'] == true || data['isFavorite'] == "true";
      } else {
        throw Exception("Failed to check favorite status");
      }
    } catch (e) {
      print("Error checking favorite status: $e");
      return false;
    }
  }

  Future<void> toggleFavorite(String userId, bool isFavorite) async {
    try {
      var res = await http.put(
        Uri.parse("$baseUrl/$userId"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"isFavorite": isFavorite}),
      );

      if (res.statusCode != 200) {
        throw Exception("Failed to update favorite status");
      }
    } catch (e) {
      print("Error updating favorite status: $e");
    }
  }
}