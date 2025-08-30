// lib/blocs/task_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/task.dart';
import '../services/storage_service.dart';
import 'task_event.dart';
import 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  TaskBloc() : super(TaskInitial()) {
    on<LoadTasks>(_onLoadTasks);
    on<AddTask>(_onAddTask);
    on<ToggleTask>(_onToggleTask);
    on<DeleteTask>(_onDeleteTask);
    on<UpdateTask>(_onUpdateTask);
  }

  Future<void> _onLoadTasks(LoadTasks event, Emitter<TaskState> emit) async {
    emit(TaskLoading());
    try {
      final tasks = await StorageService.loadTasks();
      emit(TaskLoaded(tasks));
    } catch (e) {
      emit(TaskError('Failed to load tasks: $e'));
    }
  }

  Future<void> _onAddTask(AddTask event, Emitter<TaskState> emit) async {
    try {
      final currentState = state;
      if (currentState is TaskLoaded) {
        if (event.title.trim().isNotEmpty) {
          final newTask = Task(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            title: event.title.trim(),
            createdAt: DateTime.now(),
          );

          final updatedTasks = [newTask, ...currentState.tasks];
          await StorageService.saveTasks(updatedTasks);
          
          emit(TaskLoaded(updatedTasks));
        }
      }
    } catch (e) {
      emit(TaskError('Failed to add task: $e'));
    }
  }

  Future<void> _onToggleTask(ToggleTask event, Emitter<TaskState> emit) async {
    try {
      final currentState = state;
      if (currentState is TaskLoaded) {
        final updatedTasks = currentState.tasks.map((task) {
          if (task.id == event.taskId) {
            return task.copyWith(isCompleted: !task.isCompleted);
          }
          return task;
        }).toList();

        await StorageService.saveTasks(updatedTasks);
        emit(TaskLoaded(updatedTasks));
      }
    } catch (e) {
      emit(TaskError('Failed to toggle task: $e'));
    }
  }

  Future<void> _onDeleteTask(DeleteTask event, Emitter<TaskState> emit) async {
    try {
      final currentState = state;
      if (currentState is TaskLoaded) {
        final updatedTasks = currentState.tasks
            .where((task) => task.id != event.taskId)
            .toList();

        await StorageService.saveTasks(updatedTasks);
        emit(TaskLoaded(updatedTasks));
      }
    } catch (e) {
      emit(TaskError('Failed to delete task: $e'));
    }
  }

  Future<void> _onUpdateTask(UpdateTask event, Emitter<TaskState> emit) async {
    try {
      final currentState = state;
      if (currentState is TaskLoaded) {
        final updatedTasks = currentState.tasks.map((task) {
          if (task.id == event.task.id) {
            return event.task;
          }
          return task;
        }).toList();

        await StorageService.saveTasks(updatedTasks);
        emit(TaskLoaded(updatedTasks));
      }
    } catch (e) {
      emit(TaskError('Failed to update task: $e'));
    }
  }
}
