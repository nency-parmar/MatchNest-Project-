
//import 'dart:ui';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:matrimonial_application/class_user/user.dart';
// import 'package:matrimonial_application/login_and_register_area/user_register_page.dart';
// import 'package:matrimonial_application/user_edit_add_pages/user_details.dart';
//
// class UserList extends StatefulWidget {
//   UserList({super.key});
//
//   @override
//   State<UserList> createState() => _UserListState();
// }
//
// class _UserListState extends State<UserList> {
//   bool isFavourite = false;
//   User user = User(); // Singleton User
//   TextEditingController _searchController = TextEditingController(); // Controller for search input
//   String searchQuery = ""; // Stores the current search query
//
//   void editUser(int index) async {
//     final Map<String, dynamic>? updatedUser = await Navigator.of(context)
//         .pushReplacement(MaterialPageRoute(builder: (context) => UserRegisterPage(
//       isEdit: true,
//       userDetailss: user.userList[index],
//       index: index,
//         )
//       )
//     );
//     if (updatedUser != null) {
//       setState(() {
//         user.userList[index] = updatedUser;
//       });
//     }
//   }
//
//   // Function to filter users based on the search query
//   List<Map<String, dynamic>> getFilteredUserList() {
//     if (searchQuery.isEmpty) {
//       return user.userList;
//     } else {
//       return user.userList.where((userData) {
//         return userData['name'].toLowerCase().contains(searchQuery.toLowerCase()) ||
//             userData['country'].toLowerCase().contains(searchQuery.toLowerCase()) ||
//             userData['state'].toLowerCase().contains(searchQuery.toLowerCase());
//       }).toList();
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('User List', style: TextStyle(color: Colors.white)),
//         backgroundColor: Color.fromRGBO(195, 126, 84, 0.8),
//       ),
//       body: Stack(children: [
//         Container(
//           decoration: BoxDecoration(
//             image: DecorationImage(
//               image: AssetImage('assets/image/img_2.png'),
//               fit: BoxFit.cover,
//             ),
//           ),
//         ),
//         BackdropFilter(
//           filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
//           child: Container(
//             color: Colors.black.withOpacity(0.2),
//           ),
//         ),
//         Column(
//           children: [
//             Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: TextFormField(
//                 controller: _searchController,
//                 onChanged: (query) {
//                   setState(() {
//                     searchQuery = query; // Update the search query
//                   });
//                 },
//                 decoration: InputDecoration(
//                   labelText: 'Search here',
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(15),
//                   ),
//                 ),
//               ),
//             ),
//             getFilteredUserList().isEmpty
//                 ? Center(child: Text("No Users Found"))
//                 : Expanded(
//               child: ListView.builder(
//                 itemCount: getFilteredUserList().length,
//                 itemBuilder: (context, index) {
//                   return getList(index);
//                 },
//               ),
//             ),
//           ],
//         ),
//       ]),
//     );
//   }
// //
//   Widget getList(index) {
//     var userData = getFilteredUserList()[index];
//
//     return Padding(
//       padding: const EdgeInsets.fromLTRB(9.0, 7, 9, 0),
//       child: Card(
//         elevation: 10,
//         shadowColor: Colors.grey,
//         color: Colors.white70,
//         child: ListTile(
//           onTap: () {
//             Navigator.of(context).push(MaterialPageRoute(
//                 builder: (context) => UserDetails(index: index)));
//           },
//           title: Row(
//             children: [
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text('${userData['name']}',
//                       style:
//                       TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
//                   SizedBox(
//                     height: 5,
//                   ),
//                   Row(
//                     children: [
//                       Text('${userData['age']} | ',
//                           style:
//                           TextStyle(fontSize: 12, color: Colors.black45)),
//                       Text('${userData['country']} ',
//                           style:
//                           TextStyle(fontSize: 12, color: Colors.black45)),
//                     ],
//                   ),
//                   SizedBox(
//                     height: 5,
//                   ),
//                 ],
//               ),
//             ],
//           ),
//           trailing: Row(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               IconButton(
//                 onPressed: () {
//                   showDialog(
//                       context: context,
//                       builder: (context) {
//                         return CupertinoAlertDialog(
//                           title: Text('DELETE'),
//                           content: Text('Are you sure you want to delete?'),
//                           actions: [
//                             TextButton(
//                                 onPressed: () {
//                                   setState(() {
//                                     user.deleteUser(index); // Use deleteUser method
//                                   });
//                                   Navigator.pop(context);
//                                 },
//                                 child: Text('Yes')),
//                             TextButton(
//                                 onPressed: () {
//                                   Navigator.pop(context);
//                                 },
//                                 child: Text('No'))
//                           ],
//                         );
//                       });
//                 },
//                 icon: Icon(Icons.delete, color: Colors.black),
//               ),
//               IconButton(
//                 onPressed: () {
//                   editUser(index);
//                 },
//                 icon: Icon(Icons.edit, color: Colors.black),
//               ),
//               IconButton(
//                 onPressed: () {
//                   setState(() {
//                     user.toggleFavourite(userData); // Add or remove from favourites
//                   });
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(content: Text(user.favouriteUserList.contains(userData) ? "Added to Favourites" : "Removed from Favourites")),
//                   );
//                 },
//                 icon: user.favouriteUserList.contains(userData)
//                     ? Icon(Icons.favorite, color: Colors.black)
//                     : Icon(Icons.favorite_outline, color: Colors.black),
//               ),
//             ],
//           ),
//           leading: CircleAvatar(
//             backgroundColor: index % 2 == 0 ? Colors.brown : Colors.grey,
//             child: Text(
//               userData["name"][0],
//               style: TextStyle(
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }