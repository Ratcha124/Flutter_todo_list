import 'dart:convert';

class Todo {
  String id;
  String title;
  bool isDone;

  Todo({
    required this.id,
    required this.title,
    this.isDone = false,
  });

  // แปลงเป็น Map สำหรับเก็บใน JSON
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'isDone': isDone,
    };
  }

  // สร้างจาก Map ที่แปลงจาก JSON
  factory Todo.fromMap(Map<String, dynamic> map) {
    return Todo(
      id: map['id'],
      title: map['title'],
      isDone: map['isDone'],
    );
  }

  // แปลงเป็น JSON string
  String toJson() => json.encode(toMap());

  // สร้างจาก JSON string
  factory Todo.fromJson(String source) => Todo.fromMap(json.decode(source));
}
