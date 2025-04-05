import 'dart:io';

void main()
{
  user u = new user();

  while (true)
  {
    print("Enter Your Choice : ");
    print("Enter 1 for Insert.");
    print("Enter 2 for Get User.");
    print("Enter 3 for Update.");
    print("Enter 4 for Delete.");
    print("Enter 5 for Break.");
    int choice = int.parse(stdin.readLineSync()!);

    if (choice == 1)
    {
      print("Enter User's Name : ");
      String name = stdin.readLineSync()!;
      print("Enter User's Email : ");
      String mail = stdin.readLineSync()!;
      print("Enter User's Age : ");
      int age = int.parse(stdin.readLineSync()!);
      print("Enter User's Mobile_No : ");
      int mobile = int.parse(stdin.readLineSync()!);

      u.addUser(name: name, email: mail, age: age, mobile: mobile);
    }
    else if (choice == 2)
    {
      u.getUser();
    }
    else if (choice == 3)
    {
      print("Enter id that you want to change.");
      int id = int.parse(stdin.readLineSync()!);
      print("Update User's Name : ");
      String name = stdin.readLineSync()!;
      print("Update User's Email : ");
      String mail = stdin.readLineSync()!;
      print("Update User's Age : ");
      int age = int.parse(stdin.readLineSync()!);
      print("Update User's Mobile_No : ");
      int mobile = int.parse(stdin.readLineSync()!);

      u.updateUser(id: id, name: name, email: mail, age: age, mobile: mobile);
    }
    else if (choice == 4)
    {
      print("Enter id Which you want to delete.");
      int id = int.parse(stdin.readLineSync()!);
      u.deleteUser(id: id);
    }
    else if(choice == 5)
    {
      print("Thank You!!!");
      break;
    }
    else
    {
      print("Please Enter Valid Choice.");
    }
  }
}

class user
{
  List<Map<String, dynamic>> list = [];

  // Add Users
  void addUser({required String name, required String email, required int age, required int mobile})
  {
    Map<String, dynamic> map = {};
    map['name'] = name;
    map['email'] = email;
    map['age'] = age;
    map['mobile'] = mobile;
    list.add(map);
  }

  // Get Users
  List<Map<String, dynamic>> getUser()
  {
    print(list);
    return list;
  }

  // Update Users
  void updateUser({required int id, required String name, required String email, required int age, required int mobile})
  {
    list[id]['name'] = name;
    list[id]['email'] = email;
    list[id]['age'] = age;
    list[id]['mobile'] = mobile;
  }

  // Delete Users
  void deleteUser({required int id})
  {
    list.removeAt(id);
  }

  void getById({required id})
  {

  }
}