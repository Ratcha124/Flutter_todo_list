import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/todo_model.dart';
import '../widgets/todo_item.dart';
import '../widgets/todo_form.dart';
import '../utils/constants.dart';

enum FilterStatus { all, done, notDone }

class HomeScreen extends StatefulWidget {
  final VoidCallback? onLogout;
  const HomeScreen({Key? key, this.onLogout}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Todo> _todos = [];
  FilterStatus _filterStatus = FilterStatus.all;
  final uuid = const Uuid();

  List<Todo> get filteredTodos {
    switch (_filterStatus) {
      case FilterStatus.done:
        return _todos.where((t) => t.isDone).toList();
      case FilterStatus.notDone:
        return _todos.where((t) => !t.isDone).toList();
      case FilterStatus.all:
      default:
        return _todos;
    }
  }

  void _addTodo(String title) {
    setState(() {
      _todos.add(Todo(id: uuid.v4(), title: title));
    });
  }

  void _toggleDone(Todo todo) {
    setState(() {
      final index = _todos.indexWhere((t) => t.id == todo.id);
      if (index != -1) {
        _todos[index].isDone = !_todos[index].isDone;
      }
    });
  }

  void _deleteTodo(Todo todo) {
    setState(() {
      _todos.removeWhere((t) => t.id == todo.id);
    });
  }

  void _editTodo(Todo todo, String newTitle) {
    setState(() {
      final index = _todos.indexWhere((t) => t.id == todo.id);
      if (index != -1) {
        _todos[index].title = newTitle;
      }
    });
  }

  void _showAddForm() {
    showDialog(
      context: context,
      builder: (_) => TodoForm(onSubmit: _addTodo),
    );
  }

  void _showEditForm(Todo todo) {
    showDialog(
      context: context,
      builder: (_) => TodoForm(
        initialTitle: todo.title,
        onSubmit: (newTitle) => _editTodo(todo, newTitle),
      ),
    );
  }

  Widget _buildFilterButton(FilterStatus status, String label) {
    final isSelected = _filterStatus == status;
    return ElevatedButton(
      onPressed: () => setState(() => _filterStatus = status),
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? primaryColor : Colors.grey[300],
        foregroundColor: isSelected ? Colors.white : Colors.black,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        padding: const EdgeInsets.symmetric(horizontal: 16),
      ),
      child: Text(label),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Text('ToDo List'),
        centerTitle: true,
        actions: [
          if (widget.onLogout != null)
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: widget.onLogout,
              tooltip: 'Logout',
            ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildFilterButton(FilterStatus.all, 'ทั้งหมด'),
              const SizedBox(width: 12), // เพิ่มช่องว่างกว่านิดหน่อยให้สบายตา
              _buildFilterButton(FilterStatus.notDone, 'ยังไม่เสร็จ'),
              const SizedBox(width: 12),
              _buildFilterButton(FilterStatus.done, 'เสร็จแล้ว'),
            ],
          ),
          const SizedBox(height: 12),
          Expanded(
            child: filteredTodos.isEmpty
                ? const Center(
                    child: Text('ไม่มีรายการ', style: TextStyle(fontSize: 18)))
                : ListView.builder(
                    itemCount: filteredTodos.length,
                    itemBuilder: (ctx, i) => TodoItem(
                      todo: filteredTodos[i],
                      onToggleDone: _toggleDone,
                      onDelete: _deleteTodo,
                      onEdit: _showEditForm,
                    ),
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddForm,
        backgroundColor: primaryColor,
        child: const Icon(Icons.add),
      ),
    );
  }
}
