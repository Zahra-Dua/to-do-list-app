// lib/services/storage_service.dart
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/task.dart';

class StorageService {
  static const String _tasksKey = 'tasks';
  static const String _counterKey = 'counter';

  // Save tasks to SharedPreferences
  static Future<void> saveTasks(List<Task> tasks) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String tasksJson = json.encode(
        tasks.map((task) => task.toJson()).toList(),
      );
      await prefs.setString(_tasksKey, tasksJson);
    } catch (e) {
      print('Error saving tasks: $e');
    }
  }

  // Load tasks from SharedPreferences
  static Future<List<Task>> loadTasks() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? tasksJson = prefs.getString(_tasksKey);

      if (tasksJson != null) {
        List<dynamic> tasksList = json.decode(tasksJson);
        return tasksList.map((task) => Task.fromJson(task)).toList();
      }
      return [];
    } catch (e) {
      print('Error loading tasks: $e');
      return [];
    }
  }

  // Save counter value (for counter app functionality)
  static Future<void> saveCounter(int counter) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_counterKey, counter);
    } catch (e) {
      print('Error saving counter: $e');
    }
  }

  // Load counter value
  static Future<int> loadCounter() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      return prefs.getInt(_counterKey) ?? 0;
    } catch (e) {
      print('Error loading counter: $e');
      return 0;
    }
  }

  // Clear all data
  static Future<void> clearAllData() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.clear();
    } catch (e) {
      print('Error clearing data: $e');
    }
  }
}
