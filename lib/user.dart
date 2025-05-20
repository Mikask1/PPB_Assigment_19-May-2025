class User {
  final String id;
  final String name;
  final int age;
  final String gender;
  final String hometown;
  final String? profilePicture;
  final DateTime createdAt;
  final DateTime updatedAt;

  User({
    required this.id,
    required this.name,
    required this.age,
    required this.gender,
    required this.hometown,
    this.profilePicture,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'age': age,
      'gender': gender,
      'hometown': hometown,
      'profilePicture': profilePicture,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
    };
  }

  static User fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      name: map['name'],
      age: map['age'],
      gender: map['gender'],
      hometown: map['hometown'],
      profilePicture: map['profilePicture'],
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(map['updatedAt']),
    );
  }
} 