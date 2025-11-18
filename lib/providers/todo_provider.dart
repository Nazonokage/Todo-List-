import 'package:flutter/material.dart';
import '../models/todo.dart';
import '../database/database_helper.dart';

class TodoProvider with ChangeNotifier {
  List<Todo> _todos = [];
  final DatabaseHelper _dbHelper = DatabaseHelper();

  List<Todo> get todos => _todos;

  Future<void> loadTodos() async {
    try {
      _todos = await _dbHelper.getTodos();
      print('Loaded ${_todos.length} todos from database');
      notifyListeners();
    } catch (e) {
      print('Error loading todos: $e');
    }
  }

  Future<void> addTodo(Todo todo) async {
    try {
      int id = await _dbHelper.insertTodo(todo);
      print('Added todo with id: $id');
      await loadTodos();
    } catch (e) {
      print('Error adding todo: $e');
    }
  }

  Future<void> updateTodo(Todo todo) async {
    await _dbHelper.updateTodo(todo);
    await loadTodos();
  }

  Future<void> deleteTodo(int id) async {
    await _dbHelper.deleteTodo(id);
    await loadTodos();
  }

  Future<void> toggleTodoCompletion(Todo todo) async {
    Todo updatedTodo = todo.copyWith(
      isCompleted: !todo.isCompleted,
      updatedAt: DateTime.now(),
    );
    await updateTodo(updatedTodo);
  }
}
