import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/todo_provider.dart';
import '../providers/theme_provider.dart';
import '../widgets/todo_item.dart';
import '../widgets/theme_selector.dart';
import '../widgets/particle_painter.dart';
import 'add_edit_todo_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TodoProvider>().loadTodos();
      context.read<ThemeProvider>().loadSettings();
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final todoProvider = Provider.of<TodoProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo List'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => _showThemeSelector(context),
          ),
        ],
      ),
      body: Stack(
        children: [
          // Animated particle background
          Positioned.fill(
            child: ParticleField(
              isDarkMode: themeProvider.isDarkMode,
              primaryColor: themeProvider.primaryColor,
            ),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: themeProvider.isDarkMode
                    ? [
                        Colors.black.withOpacity(0.9),
                        Colors.grey.shade900.withOpacity(0.9),
                      ]
                    : [
                        Colors.white.withOpacity(0.9),
                        Colors.grey.shade100.withOpacity(0.9),
                      ],
              ),
            ),
            child: todoProvider.todos.isEmpty
                ? const Center(
                    child: Text(
                      'No todos yet. Add one!',
                      style: TextStyle(fontSize: 18),
                    ),
                  )
                : ListView.builder(
                    itemCount: todoProvider.todos.length,
                    itemBuilder: (context, index) {
                      return TodoItem(todo: todoProvider.todos[index]);
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addTodo(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showThemeSelector(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => const ThemeSelector(),
    );
  }

  void _addTodo(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddEditTodoScreen()),
    );
  }
}
