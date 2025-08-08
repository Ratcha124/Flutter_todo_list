import 'package:flutter/material.dart';
import '../models/todo_model.dart';
import '../utils/constants.dart';

class TodoItem extends StatelessWidget {
  final Todo todo;
  final Function(Todo) onToggleDone;
  final Function(Todo) onDelete;
  final Function(Todo) onEdit;

  const TodoItem({
    Key? key,
    required this.todo,
    required this.onToggleDone,
    required this.onDelete,
    required this.onEdit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Checkbox(
          value: todo.isDone,
          onChanged: (_) => onToggleDone(todo),
          activeColor: primaryColor,
        ),
        title: Text(
          todo.title,
          style: TextStyle(
            decoration: todo.isDone ? TextDecoration.lineThrough : null,
            color: todo.isDone ? Colors.grey : textColor,
            fontWeight: FontWeight.w600,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: primaryColor),
              onPressed: () => onEdit(todo),
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.redAccent),
              onPressed: () => onDelete(todo),
            ),
          ],
        ),
      ),
    );
  }
}
