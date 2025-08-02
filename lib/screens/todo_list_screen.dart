// lib/screens/todo_list_screen.dart
import 'package:flutter/material.dart';
import '../models/task.dart';
import '../services/storage_service.dart';
import '../widgets/task_item.dart';
import '../widgets/add_task_widget.dart';
import 'counter_screen.dart';

class TodoListScreen extends StatefulWidget {
  @override
  _TodoListScreenState createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen>
    with TickerProviderStateMixin {
  List<Task> _tasks = [];
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 500),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
    _loadTasks();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // Load tasks from storage
  _loadTasks() async {
    List<Task> loadedTasks = await StorageService.loadTasks();
    setState(() {
      _tasks = loadedTasks;
    });
    _animationController.forward();
  }

  // Save tasks to storage
  _saveTasks() async {
    await StorageService.saveTasks(_tasks);
  }

  // Add new task
  _addTask(String title) {
    if (title.trim().isNotEmpty) {
      setState(() {
        _tasks.insert(
          0,
          Task(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            title: title.trim(),
            createdAt: DateTime.now(),
          ),
        );
      });
      _saveTasks();

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white),
              SizedBox(width: 8),
              Text('Task added successfully!'),
            ],
          ),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  // Toggle task completion
  _toggleTask(int index) {
    setState(() {
      _tasks[index].isCompleted = !_tasks[index].isCompleted;
    });
    _saveTasks();
  }

  // Delete task
  _deleteTask(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Text('Delete Task'),
          content: Text('Are you sure you want to delete this task?'),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text('Delete', style: TextStyle(color: Colors.red)),
              onPressed: () {
                setState(() {
                  _tasks.removeAt(index);
                });
                _saveTasks();
                Navigator.of(context).pop();

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Row(
                      children: [
                        Icon(Icons.delete, color: Colors.white),
                        SizedBox(width: 8),
                        Text('Task deleted!'),
                      ],
                    ),
                    backgroundColor: Colors.red,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  // Clear all completed tasks
  _clearCompletedTasks() {
    int completedCount = _tasks.where((task) => task.isCompleted).length;
    if (completedCount == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No completed tasks to clear!'),
          backgroundColor: Colors.orange,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Text('Clear Completed Tasks'),
          content: Text(
            'Are you sure you want to remove $completedCount completed task${completedCount > 1 ? 's' : ''}?',
          ),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text('Clear', style: TextStyle(color: Colors.red)),
              onPressed: () {
                setState(() {
                  _tasks.removeWhere((task) => task.isCompleted);
                });
                _saveTasks();
                Navigator.of(context).pop();

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      '$completedCount completed task${completedCount > 1 ? 's' : ''} cleared!',
                    ),
                    backgroundColor: Colors.orange,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  // Navigate to counter screen
  _navigateToCounter() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CounterScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    int completedTasks = _tasks.where((task) => task.isCompleted).length;
    int totalTasks = _tasks.length;
    double progress = totalTasks > 0 ? completedTasks / totalTasks : 0.0;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [Color(0xFFA18CD1), Color(0xFFFBC2EB)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header with navigation
              Container(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'My Tasks',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Row(
                          children: [
                            // Counter app button
                            IconButton(
                              icon: Icon(Icons.calculate, color: Colors.white),
                              onPressed: _navigateToCounter,
                              tooltip: 'Counter App',
                            ),
                            // Clear completed tasks button
                            if (_tasks.any((task) => task.isCompleted))
                              IconButton(
                                icon: Icon(
                                  Icons.clear_all,
                                  color: Colors.white,
                                ),
                                onPressed: _clearCompletedTasks,
                                tooltip: 'Clear completed tasks',
                              ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 15),

                    // Progress indicator
                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.task_alt,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    '$completedTasks of $totalTasks completed',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                '${(progress * 100).toInt()}%',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: LinearProgressIndicator(
                              value: progress,
                              backgroundColor: Colors.white.withOpacity(0.3),
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                              minHeight: 6,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Add task widget
              AddTaskWidget(onAddTask: _addTask),

              // Tasks list
              Expanded(
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: _tasks.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.task_outlined,
                                size: 100,
                                color: Colors.white.withOpacity(0.5),
                              ),
                              SizedBox(height: 20),
                              Text(
                                'No tasks yet!',
                                style: TextStyle(
                                  fontSize: 28,
                                  color: Colors.white.withOpacity(0.8),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Add a task to get started',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white.withOpacity(0.6),
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          itemCount: _tasks.length,
                          itemBuilder: (context, index) {
                            return TaskItem(
                              task: _tasks[index],
                              index: index,
                              onToggle: () => _toggleTask(index),
                              onDelete: () => _deleteTask(index),
                            );
                          },
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
