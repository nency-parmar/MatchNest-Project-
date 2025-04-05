import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
import 'package:path/path.dart';
import 'package:matrimony_application/Design/utils/user.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io' if (dart.library.io) 'dart:io';

class UserDBHelper {
  static final UserDBHelper instance = UserDBHelper._internal(); // Singleton instance
  UserDBHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDB();
    return _database!;
  }

  // Method to check the table structure (for debugging)
  Future<void> checkTableStructure() async {
    final db = await database;
    List<Map<String, dynamic>> result = await db.rawQuery("PRAGMA table_info(users)");

    print("Users Table Structure:");
    for (var row in result) {
      print("Column: ${row['name']}, Type: ${row['type']}, Nullable: ${row['notnull'] == 0}");
    }
  }

  // Initialize the database
  Future<Database> initDB() async {
    DatabaseFactory dbFactory;

    if (kIsWeb) {
      dbFactory = databaseFactoryFfiWeb;
    } else {
      sqfliteFfiInit();
      dbFactory = databaseFactoryFfi;
    }

    String dbPath;
    if (kIsWeb) {
      dbPath = 'users.db';
    } else {
      final databasesPath = await getDatabasesPath();
      dbPath = join(databasesPath, 'users.db');

      if (!await Directory(databasesPath).exists()) {
        await Directory(databasesPath).create(recursive: true);
      }
    }

    final db = await dbFactory.openDatabase(
      dbPath,
      options: OpenDatabaseOptions(
        version: 3, // Increment version number for schema changes
        onCreate: (Database db, int version) async {
          await db.execute('''
            CREATE TABLE users (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              name TEXT,
              email TEXT,
              city TEXT,
              hobbies TEXT,
              gender TEXT,
              num TEXT,
              age INTEGER,  
              pass TEXT,
              religion TEXT,
              qualification TEXT,
              occupation TEXT,
              isFavorite INTEGER DEFAULT 0
            )
          ''');
          print("✅ Table 'users' created successfully!");
        },
        onUpgrade: (Database db, int oldVersion, int newVersion) async {
          for (int version = oldVersion + 1; version <= newVersion; version++) {
            switch (version) {
              case 2:
                await db.execute('ALTER TABLE users ADD COLUMN age INTEGER;');
                print("✅ Column 'age' added successfully!");
                break;
              case 3:
                List<Map<String, dynamic>> columns = await db.rawQuery("PRAGMA table_info(users)");
                bool columnExists = columns.any((column) => column['name'] == 'isFavorite');

                if (!columnExists) {
                  await db.execute('ALTER TABLE users ADD COLUMN isFavorite INTEGER DEFAULT 0;');
                  print("✅ Column 'isFavorite' added successfully!");
                } else {
                  print("⚠️ Column 'isFavorite' already exists!");
                }
                break;
              default:
                print("⚠️ No upgrade logic for version $version");
            }
          }
        },
      ),
    );

    return db;
  }

  // Add a new user
  Future<int> addUser(AppUser user) async {
    try {
      final db = await database;
      return await db.insert('users', user.toMap());
    } catch (e) {
      print("Error adding user: $e");
      return 0;
    }
  }

  // Get all users
  Future<List<AppUser>> getUsers() async {
    try {
      final db = await database;
      final List<Map<String, dynamic>> maps = await db.query('users');
      return List.generate(maps.length, (i) => AppUser.fromMap(maps[i]));
    } catch (e) {
      print("Error fetching users: $e");
      return [];
    }
  }

  // Update a user
  Future<int> updateUser(AppUser user) async {
    try {
      final db = await database;

      if (user.id == null) {
        print("Error: User ID is null. Cannot update user.");
        return 0;
      }

      int result = await db.update(
        'users',
        user.toMap(),
        where: 'id = ?',
        whereArgs: [user.id],
      );

      if (result > 0) {
        print("User updated successfully: ${user.name}");
      } else {
        print("Warning: No user updated. Check if the ID exists.");
      }

      return result;
    } catch (e) {
      print("Error updating user: $e");
      return 0;
    }
  }

  // Delete a user
  Future<int> deleteUser(int id) async {
    try {
      final db = await database;
      return await db.delete(
        'users',
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      print("Error deleting user: $e");
      return 0;
    }
  }

  // Toggle favorite status
  Future<int> toggleFavorite(int id, bool isFavorite) async {
    try {
      final db = await database;
      return await db.update(
        'users',
        {'isFavorite': isFavorite ? 1 : 0},
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      print("Error toggling favorite: $e");
      return 0;
    }
  }

  // Get favorite users
  Future<List<AppUser>> getFavoriteUsers() async {
    try {
      final db = await database;
      final List<Map<String, dynamic>> maps = await db.query(
        'users',
        where: 'isFavorite = ?',
        whereArgs: [1],
      );
      return List.generate(maps.length, (i) => AppUser.fromMap(maps[i]));
    } catch (e) {
      print("Error fetching favorite users: $e");
      return [];
    }
  }
}