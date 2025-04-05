class AppUser {
  String? id;
  String name;
  String email;
  String num;
  int? age;
  String? dob;
  String? city;
  String? hobbies;
  String? gender;
  String? religion;
  String? qualification;
  String? occupation;
  String pass;
  bool isFavorite;

  AppUser({
    this.id,
    required this.name,
    required this.email,
    required this.num,
    this.age,
    this.dob,
    this.city,
    this.hobbies,
    this.gender,
    this.religion,
    this.qualification,
    this.occupation,
    required this.pass,
    this.isFavorite = false,
  });

  factory AppUser.fromMap(Map<String, dynamic> json) {
    return AppUser(
      id: json['id'].toString(),
      name: json['name'] ?? "",
      email: json['email'] ?? "",
      num: json['num'] ?? "",
      age: int.tryParse(json['age'].toString()) ?? 0,
      dob: json['dob'] ?? "",
      city: json['city'] ?? "",
      hobbies: json['hobbies'] ?? "",
      gender: json['gender'] ?? "",
      religion: json['religion'] ?? "",
      qualification: json['qualification'] ?? "",
      occupation: json['occupation'] ?? "",
      pass: json['pass'] ?? "",
      isFavorite: json['isFavorite'] == true || json['isFavorite'] == "true",
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "email": email,
      "num": num,
      "age": age.toString(),
      "dob": dob,
      "city": city,
      "hobbies": hobbies,
      "gender": gender,
      "religion": religion,
      "qualification": qualification,
      "occupation": occupation,
      "pass": pass,
      "isFavorite": isFavorite.toString(),
    };
  }

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      id: json['id']?.toString(),
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      num: json['num'] ?? '',
      age: int.tryParse(json['age'].toString()) ?? 0,
      dob: json['dob'] ?? '',
      city: json['city'] ?? '',
      hobbies: json['hobbies'] ?? '',
      gender: json['gender'] ?? '',
      religion: json['religion'] ?? '',
      qualification: json['qualification'] ?? '',
      occupation: json['occupation'] ?? '',
      pass: json['pass'] ?? '',
      isFavorite: json['isFavorite'] == true || json['isFavorite'] == "true",
    );
  }
}