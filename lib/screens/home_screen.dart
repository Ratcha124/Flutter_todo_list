import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../models/todo_model.dart';
import '../widgets/todo_item.dart';
import '../widgets/todo_form.dart';
import '../utils/constants.dart';

enum FilterStatus { all, done, notDone }

class HomeScreen extends StatefulWidget {
  final VoidCallback? onLogout; // ถ้าต้องการใช้ปุ่ม logout

  const HomeScreen({Key? key, this.onLogout}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Todo> _todos = [];
  FilterStatus _filterStatus = FilterStatus.all;
  final Uuid _uuid = const Uuid();

  @override
  void initState() {
    super.initState();
    _loadTodos();
  }

  Future<void> _loadTodos() async {
    final prefs = await SharedPreferences.getInstance();
    final String? todosString = prefs.getString('todos');
    if (todosString != null) {
      final List<dynamic> decoded = json.decode(todosString);
      setState(() {
        _todos.clear();
        _todos.addAll(decoded.map((item) => Todo.fromMap(item)));
      });
    }
  }

  Future<void> _saveTodos() async {
    final prefs = await SharedPreferences.getInstance();
    final String encodedData =
        json.encode(_todos.map((t) => t.toMap()).toList());
    await prefs.setString('todos', encodedData);
  }

  List<Todo> get filteredTodos {
    switch (_filterStatus) {
      case FilterStatus.done:
        return _todos.where((todo) => todo.isDone).toList();
      case FilterStatus.notDone:
        return _todos.where((todo) => !todo.isDone).toList();
      case FilterStatus.all:
      default:
        return _todos;
    }
  }

  void _addTodo(String title) {
    setState(() {
      _todos.add(Todo(id: _uuid.v4(), title: title));
    });
    _saveTodos();
  }

  void _toggleDone(Todo todo) {
    setState(() {
      final index = _todos.indexWhere((t) => t.id == todo.id);
      if (index != -1) {
        _todos[index].isDone = !_todos[index].isDone;
      }
    });
    _saveTodos();
  }

  void _deleteTodo(Todo todo) {
    setState(() {
      _todos.removeWhere((t) => t.id == todo.id);
    });
    _saveTodos();
  }

  void _editTodo(Todo todo, String newTitle) {
    setState(() {
      final index = _todos.indexWhere((t) => t.id == todo.id);
      if (index != -1) {
        _todos[index].title = newTitle;
      }
    });
    _saveTodos();
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
    final bool isSelected = _filterStatus == status;
    return ElevatedButton(
      onPressed: () => setState(() => _filterStatus = status),
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? primaryColor : Colors.grey[300],
        foregroundColor: isSelected ? Colors.white : Colors.black87,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        elevation: isSelected ? 4 : 0,
      ),
      child: Text(
        label,
        style: TextStyle(
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text('ToDo List'),
        actions: [
          if (widget.onLogout != null)
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: widget.onLogout,
              tooltip: 'Logout',
            ),
        ],
        centerTitle: true,
        elevation: 6,
        shadowColor: Colors.black38,
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildFilterButton(FilterStatus.all, 'ทั้งหมด'),
              const SizedBox(width: 12),
              _buildFilterButton(FilterStatus.notDone, 'ยังไม่เสร็จ'),
              const SizedBox(width: 12),
              _buildFilterButton(FilterStatus.done, 'เสร็จแล้ว'),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: filteredTodos.isEmpty
                ? Center(
                    child: Text(
                      'ไม่มีรายการ',
                      style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                    ),
                  )
                : ListView.builder(
                    itemCount: filteredTodos.length,
                    itemBuilder: (context, index) {
                      final todo = filteredTodos[index];
                      return TodoItem(
                        todo: todo,
                        onToggleDone: _toggleDone,
                        onDelete: _deleteTodo,
                        onEdit: _showEditForm,
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddForm,
        backgroundColor: primaryColor,
        child: const Icon(Icons.add, size: 28),
        elevation: 6,
        tooltip: 'เพิ่มรายการใหม่',
      ),
    );
  }
}
