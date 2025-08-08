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

  // แปลงเป็น Map (เพื่อเก็บเป็น JSON)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'isDone': isDone,
    };
  }

  // สร้าง Todo จาก Map (โหลด JSON กลับมา)
  factory Todo.fromMap(Map<String, dynamic> map) {
    return Todo(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      isDone: map['isDone'] ?? false,
    );
  }

  // (ไม่บังคับ) แปลงเป็น JSON string
  String toJson() => json.encode(toMap());

  // (ไม่บังคับ) สร้างจาก JSON string
  factory Todo.fromJson(String source) => Todo.fromMap(json.decode(source));
}
