// lib/widgets/add_task_widget.dart
import 'package:flutter/material.dart';

class AddTaskWidget extends StatefulWidget {
  final Function(String) onAddTask;

  const AddTaskWidget({Key? key, required this.onAddTask}) : super(key: key);

  @override
  _AddTaskWidgetState createState() => _AddTaskWidgetState();
}

class _AddTaskWidgetState extends State<AddTaskWidget>
    with SingleTickerProviderStateMixin {
  final TextEditingController _taskController = TextEditingController();
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _taskController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _handleAddTask() {
    if (_taskController.text.trim().isNotEmpty) {
      widget.onAddTask(_taskController.text.trim());
      _taskController.clear();

      // Button press animation
      _animationController.forward().then((_) {
        _animationController.reverse();
      });
    } else {
      // Shake animation for empty input
      _shakeTextField();
    }
  }

  void _shakeTextField() {
    // Simple shake effect by changing border color temporarily
    setState(() {});
    Future.delayed(Duration(milliseconds: 100), () {
      if (mounted) setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 15,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          // Task input field
          Expanded(
            child: TextField(
              controller: _taskController,
              decoration: InputDecoration(
                hintText: 'Add a new task...',
                hintStyle: TextStyle(color: Colors.grey[400], fontSize: 16),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 18,
                ),
              ),
              style: TextStyle(fontSize: 16, color: Colors.black87),
              onSubmitted: (_) => _handleAddTask(),
              textCapitalization: TextCapitalization.sentences,
            ),
          ),

          // Add button
          AnimatedBuilder(
            animation: _scaleAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _scaleAnimation.value,
                child: GestureDetector(
                  onTap: _handleAddTask,
                  child: Container(
                    margin: EdgeInsets.all(8),
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFFA18CD1), Color(0xFFFBC2EB)],
                      ),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xFFA18CD1).withOpacity(0.3),
                          spreadRadius: 1,
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(Icons.add, color: Colors.white, size: 24),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
