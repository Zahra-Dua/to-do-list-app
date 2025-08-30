# BLoC Implementation Guide

This document explains the BLoC (Business Logic Component) pattern implementation in the Todo List App.

## 🎯 What is BLoC?

BLoC (Business Logic Component) is a design pattern that helps separate business logic from the UI layer. It was created by Google and is widely used in Flutter applications for state management.

## 🏗️ BLoC Architecture

### Core Components

1. **Events** - Input to the BLoC (user actions, API calls, etc.)
2. **States** - Output from the BLoC (UI state)
3. **BLoC** - Business Logic Component that converts Events to States

```
UI → Events → BLoC → States → UI
```

## 📁 Project Structure

```
lib/blocs/
├── task_bloc.dart       # Task management business logic
├── task_event.dart      # Task-related events
├── task_state.dart      # Task-related states
├── counter_bloc.dart    # Counter management business logic
├── counter_event.dart   # Counter-related events
└── counter_state.dart   # Counter-related states
```

## 🔧 Implementation Details

### 1. Task BLoC Implementation

#### Events (task_event.dart)
```dart
abstract class TaskEvent extends Equatable {
  const TaskEvent();
  
  @override
  List<Object?> get props => [];
}

class LoadTasks extends TaskEvent {}
class AddTask extends TaskEvent {
  final String title;
  const AddTask(this.title);
}
class ToggleTask extends TaskEvent {
  final String taskId;
  const ToggleTask(this.taskId);
}
class DeleteTask extends TaskEvent {
  final String taskId;
  const DeleteTask(this.taskId);
}
class UpdateTask extends TaskEvent {
  final Task task;
  const UpdateTask(this.task);
}
```

#### States (task_state.dart)
```dart
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
}
class TaskError extends TaskState {
  final String message;
  const TaskError(this.message);
}
class TaskSuccess extends TaskState {
  final String message;
  const TaskSuccess(this.message);
}
```

#### BLoC (task_bloc.dart)
```dart
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

  // Other event handlers...
}
```

### 2. Counter BLoC Implementation

#### Events (counter_event.dart)
```dart
abstract class CounterEvent extends Equatable {
  const CounterEvent();
  
  @override
  List<Object?> get props => [];
}

class IncrementCounter extends CounterEvent {}
class DecrementCounter extends CounterEvent {}
class ResetCounter extends CounterEvent {}
```

#### States (counter_state.dart)
```dart
abstract class CounterState extends Equatable {
  const CounterState();
  
  @override
  List<Object?> get props => [];
}

class CounterInitial extends CounterState {
  final int count;
  const CounterInitial(this.count);
}
```

#### BLoC (counter_bloc.dart)
```dart
class CounterBloc extends Bloc<CounterEvent, CounterState> {
  CounterBloc() : super(CounterInitial(0)) {
    on<IncrementCounter>(_onIncrementCounter);
    on<DecrementCounter>(_onDecrementCounter);
    on<ResetCounter>(_onResetCounter);
  }

  void _onIncrementCounter(IncrementCounter event, Emitter<CounterState> emit) {
    final currentState = state;
    if (currentState is CounterInitial) {
      emit(CounterInitial(currentState.count + 1));
    }
  }

  // Other event handlers...
}
```

## 🎨 UI Integration

### Using BLoC in Widgets

#### BlocProvider
```dart
BlocProvider(
  create: (context) => TaskBloc()..add(LoadTasks()),
  child: MaterialApp(
    // App content
  ),
)
```

#### BlocBuilder
```dart
BlocBuilder<TaskBloc, TaskState>(
  builder: (context, state) {
    if (state is TaskLoading) {
      return CircularProgressIndicator();
    }
    if (state is TaskLoaded) {
      return ListView.builder(
        itemCount: state.tasks.length,
        itemBuilder: (context, index) {
          return TaskItem(task: state.tasks[index]);
        },
      );
    }
    return Container();
  },
)
```

#### BlocListener
```dart
BlocListener<TaskBloc, TaskState>(
  listener: (context, state) {
    if (state is TaskSuccess) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(state.message)),
      );
    }
  },
  child: // Your widget
)
```

#### Dispatching Events
```dart
// Add a task
context.read<TaskBloc>().add(AddTask('New Task'));

// Toggle task completion
context.read<TaskBloc>().add(ToggleTask(taskId));

// Delete a task
context.read<TaskBloc>().add(DeleteTask(taskId));
```

## 🧪 Testing BLoCs

### Unit Testing
```dart
test('should emit TaskLoaded when LoadTasks is added', () async {
  final bloc = TaskBloc();
  
  bloc.add(LoadTasks());
  
  await expectLater(
    bloc.stream,
    emitsInOrder([
      isA<TaskLoading>(),
      isA<TaskLoaded>(),
    ]),
  );
});
```

### Widget Testing
```dart
testWidgets('should display tasks when loaded', (tester) async {
  await tester.pumpWidget(
    BlocProvider(
      create: (context) => TaskBloc()..add(LoadTasks()),
      child: MaterialApp(home: TodoListScreen()),
    ),
  );
  
  await tester.pump();
  
  expect(find.byType(TaskItem), findsWidgets);
});
```

## 🚀 Benefits of BLoC Pattern

### 1. Separation of Concerns
- **Business Logic** is separated from UI code
- **UI** only handles presentation
- **BLoC** handles all business logic

### 2. Testability
- Easy to unit test business logic
- Mock dependencies easily
- Predictable state changes

### 3. Reusability
- BLoCs can be reused across different widgets
- Share state between multiple screens
- Consistent business logic

### 4. Performance
- Only affected widgets rebuild
- Efficient state management
- Minimal memory usage

### 5. Debugging
- Clear event flow
- Predictable state transitions
- Easy to trace issues

## 🔄 State Management Flow

```
1. User Action (e.g., tap button)
   ↓
2. Widget dispatches Event
   ↓
3. BLoC receives Event
   ↓
4. BLoC processes business logic
   ↓
5. BLoC emits new State
   ↓
6. UI rebuilds based on new State
```

## 📊 Comparison: setState vs BLoC

| Aspect | setState | BLoC |
|--------|----------|------|
| **Separation of Concerns** | ❌ Mixed | ✅ Separated |
| **Testability** | ❌ Difficult | ✅ Easy |
| **Reusability** | ❌ Limited | ✅ High |
| **Performance** | ❌ Inefficient | ✅ Efficient |
| **Debugging** | ❌ Hard | ✅ Easy |
| **Scalability** | ❌ Poor | ✅ Excellent |

## 🎯 Best Practices

### 1. Event Naming
- Use descriptive names: `AddTask`, `DeleteTask`
- Use present tense: `LoadTasks`, not `LoadedTasks`
- Be specific: `ToggleTaskCompletion`, not `ToggleTask`

### 2. State Design
- Keep states immutable
- Use `copyWith` for updates
- Include all necessary data in state

### 3. Error Handling
- Always handle errors in BLoC
- Emit error states
- Provide meaningful error messages

### 4. Performance
- Use `BlocBuilder` for UI updates
- Use `BlocListener` for side effects
- Avoid unnecessary state emissions

### 5. Testing
- Test all events and states
- Mock external dependencies
- Test error scenarios

## 🔧 Advanced Features

### 1. Multiple BLoCs
```dart
MultiBlocProvider(
  providers: [
    BlocProvider<TaskBloc>(create: (context) => TaskBloc()),
    BlocProvider<CounterBloc>(create: (context) => CounterBloc()),
  ],
  child: App(),
)
```

### 2. BLoC to BLoC Communication
```dart
// Using BlocListener
BlocListener<TaskBloc, TaskState>(
  listener: (context, state) {
    if (state is TaskLoaded) {
      context.read<CounterBloc>().add(UpdateTaskCount(state.tasks.length));
    }
  },
  child: // Your widget
)
```

### 3. Repository Pattern
```dart
class TaskRepository {
  Future<List<Task>> loadTasks() async {
    // Implementation
  }
  
  Future<void> saveTasks(List<Task> tasks) async {
    // Implementation
  }
}

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final TaskRepository repository;
  
  TaskBloc(this.repository) : super(TaskInitial()) {
    // Event handlers
  }
}
```

## 📚 Additional Resources

- [BLoC Documentation](https://bloclibrary.dev/)
- [Flutter BLoC Package](https://pub.dev/packages/flutter_bloc)
- [BLoC Testing](https://pub.dev/packages/bloc_test)
- [Equatable Package](https://pub.dev/packages/equatable)

---

This implementation demonstrates a clean, scalable, and maintainable approach to state management in Flutter applications using the BLoC pattern.
