// lib/screens/counter_screen.dart
import 'package:flutter/material.dart';
import '../services/storage_service.dart';

class CounterScreen extends StatefulWidget {
  @override
  _CounterScreenState createState() => _CounterScreenState();
}

class _CounterScreenState extends State<CounterScreen>
    with TickerProviderStateMixin {
  int _counter = 0;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );
    _loadCounter();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // Load counter value from storage
  _loadCounter() async {
    int savedCounter = await StorageService.loadCounter();
    setState(() {
      _counter = savedCounter;
    });
  }

  // Save counter value to storage
  _saveCounter() async {
    await StorageService.saveCounter(_counter);
  }

  // Increment counter
  _incrementCounter() {
    setState(() {
      _counter++;
    });
    _saveCounter();
    _animationController.forward().then((_) {
      _animationController.reverse();
    });
  }

  // Decrement counter
  _decrementCounter() {
    setState(() {
      _counter--;
    });
    _saveCounter();
    _animationController.forward().then((_) {
      _animationController.reverse();
    });
  }

  // Reset counter
  _resetCounter() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Reset Counter'),
          content: Text('Are you sure you want to reset the counter to 0?'),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text('Reset', style: TextStyle(color: Colors.red)),
              onPressed: () {
                setState(() {
                  _counter = 0;
                });
                _saveCounter();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Header
              Text(
                'Counter App',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 20),

              // Counter display
              Container(
                padding: EdgeInsets.all(30),
                margin: EdgeInsets.symmetric(horizontal: 40),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      spreadRadius: 5,
                      blurRadius: 15,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      'Current Count',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 10),
                    AnimatedBuilder(
                      animation: _scaleAnimation,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: _scaleAnimation.value,
                          child: Text(
                            '$_counter',
                            style: TextStyle(
                              fontSize: 72,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFA18CD1),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),

              SizedBox(height: 40),

              // Control buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Decrement button
                  FloatingActionButton(
                    heroTag: "decrement",
                    onPressed: _decrementCounter,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.remove,
                      color: Color(0xFFA18CD1),
                      size: 30,
                    ),
                  ),

                  // Reset button
                  FloatingActionButton(
                    heroTag: "reset",
                    onPressed: _resetCounter,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.refresh, color: Colors.orange, size: 30),
                  ),

                  // Increment button
                  FloatingActionButton(
                    heroTag: "increment",
                    onPressed: _incrementCounter,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.add, color: Color(0xFFA18CD1), size: 30),
                  ),
                ],
              ),

              SizedBox(height: 40),

              // Instructions
              Container(
                margin: EdgeInsets.symmetric(horizontal: 40),
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  children: [
                    Text(
                      'Instructions',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      '• Tap + to increase counter\n• Tap - to decrease counter\n• Tap refresh to reset counter\n• Your count is automatically saved!',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.9),
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
