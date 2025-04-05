import 'package:flutter/material.dart';

void main() {
  runApp(UserCrudApp());
}

class UserCrudApp extends StatefulWidget {
  @override
  State<UserCrudApp> createState() => _UserCrudAppState();
}

class _UserCrudAppState extends State<UserCrudApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CRUD App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: UserListPage(),
    );
  }
}

class User {
  String name, email, city;
  int age;

  User({required this.name, required this.age, required this.email, required this.city});
}

class UserListPage extends StatefulWidget {
  @override
  _UserListPageState createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {
  final List<User> userList = [];
  final TextEditingController searchController = TextEditingController();
  String searchQuery = '';

  void addUser(User user) {
    setState(() {
      userList.add(user);
    });
  }

  void updateUser(int index, User updatedUser) {
    setState(() {
      userList[index] = updatedUser;
    });
  }

  void deleteUser(int index) {
    setState(() {
      userList.removeAt(index);
    });
  }

  void showUserForm({User? user, int? index}) {
    final _nameController = TextEditingController(text: user?.name ?? '');
    final _ageController = TextEditingController(text: user?.age.toString() ?? '');
    final _emailController = TextEditingController(text: user?.email ?? '');
    final _cityController = TextEditingController(text: user?.city ?? '');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(user == null ? 'Add User' : 'Edit User'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: _ageController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Age'),
              ),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
              ),
              TextField(
                controller: _cityController,
                decoration: InputDecoration(labelText: 'City'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final name = _nameController.text;
              final age = int.tryParse(_ageController.text) ?? 0;
              final email = _emailController.text;
              final city = _cityController.text;

              if (name.isNotEmpty && email.isNotEmpty && city.isNotEmpty) {
                final newUser = User(name: name, age: age, email: email, city: city);
                if (user == null) {
                  addUser(newUser);
                } else if (index != null) {
                  updateUser(index, newUser);
                }
                Navigator.of(context).pop();
              }
            },
            child: Text(user == null ? 'Add' : 'Update'),
          ),
        ],
      ),
    );
  }

  List<User> get filteredUsers {
    if (searchQuery.isEmpty) {
      return userList;
    }
    return userList
        .where((user) =>
    user.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
        user.email.toLowerCase().contains(searchQuery.toLowerCase()) ||
        user.city.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User List'),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Search by name, email, or city',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/photo2.jpeg'),
            fit: BoxFit.cover,
          ),
        ),
        child: filteredUsers.isEmpty
            ? Center(child: Text('No users found!'))
            : ListView.builder(
          itemCount: filteredUsers.length,
          itemBuilder: (context, index) {
            final user = filteredUsers[index];
            return ListTile(
              title: Text(user.name),
              subtitle:
              Text('${user.age} years old, ${user.email}, ${user.city}'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit, color: Colors.blue),
                    onPressed: () => showUserForm(user: user, index: index),
                  ),
                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () => deleteUser(index),
                  ),
                ],
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showUserForm(),
        child: Icon(Icons.add),
      ),
    );
  }
}