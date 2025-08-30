// lib/blocs/task_state.dart
import 'package:equatable/equatable.dart';
import '../models/task.dart';

abstract class TaskState extends Equatable {
  const TaskState();

  @override
  List<Object?> get props => [];
}

class TaskInitial extends TaskState {}

class TaskLoading extends TaskState {}

class TaskLoaded extends TaskState {
  final List<Task> tasks;

  const TaskLoaded(this.tasks);

  @override
  List<Object?> get props => [tasks];

  TaskLoaded copyWith({
    List<Task>? tasks,
  }) {
    return TaskLoaded(
      tasks ?? this.tasks,
    );
  }
}

class TaskError extends TaskState {
  final String message;

  const TaskError(this.message);

  @override
  List<Object?> get props => [message];
}

class TaskSuccess extends TaskState {
  final String message;

  const TaskSuccess(this.message);

  @override
  List<Object?> get props => [message];
}
