class Book {
  String title;
  String text;
  String id;
  String userId;
  DateTime createdAt;
  DateTime updatedAt;
  String? imagePath;
  
  Book({
    required this.title,
    required this.text,
    required this.id,
    required this.userId,
    required this.createdAt, 
    required this.updatedAt,
    this.imagePath,
  });
  
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'text': text,
      'userId': userId,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
      'imagePath': imagePath,
    };
  }

  factory Book.fromMap(Map<String, dynamic> map) {
    return Book(
      id: map['id'],
      title: map['title'],
      text: map['text'],
      userId: map['userId'],
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(map['updatedAt']),
      imagePath: map['imagePath'],
    );
  }
}