class User {
  final int id;
  final String name;
  final String email;
  final String? password;
  final int? age;
  final String? gender;
  final String? avatar;
  final String? phone;
  final String? address;
  final String? createdAt;
  final String? updatedAt;
  final String? token;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.password,
    this.age,
    this.gender,
    this.avatar,
    this.phone,
    this.address,
    this.createdAt,
    this.updatedAt,
    this.token,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      password: json['password'],
      age: json['age'],
      gender: json['gender'],
      avatar: json['avatar'],
      phone: json['phone'],
      address: json['address'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      token: json['token'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'password': password,
      'age': age,
      'gender': gender,
      'avatar': avatar,
      'phone': phone,
      'address': address,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'token': token,
    };
  }
}
