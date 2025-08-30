# Todo List App with BLoC State Management

A modern Flutter application demonstrating state management using the BLoC (Business Logic Component) pattern. This app includes a Todo List manager and a Counter app, both implemented with clean architecture principles.

## 🚀 Features

### Todo List App
- ✅ Add, edit, delete, and toggle tasks
- 🎨 Beautiful Material Design 3 UI with animations
- 💾 Persistent storage using SharedPreferences
- 🔄 Real-time state updates with BLoC
- 📱 Responsive design for all screen sizes
- 🎯 Task completion tracking
- ⚡ Smooth animations and transitions

### Counter App
- ➕ Increment and decrement counter
- 🔄 Reset counter functionality
- 📊 Visual status indicators (Positive/Negative/Zero)
- 🎨 Animated counter display
- 📱 Modern UI with gradient backgrounds

## 🏗️ Architecture

This project follows the BLoC (Business Logic Component) pattern for state management:

```
lib/
├── blocs/                    # Business Logic Components
│   ├── task_bloc.dart       # Task management BLoC
│   ├── task_event.dart      # Task events
│   ├── task_state.dart      # Task states
│   ├── counter_bloc.dart    # Counter management BLoC
│   ├── counter_event.dart   # Counter events
│   └── counter_state.dart   # Counter states
├── models/                   # Data models
│   └── task.dart            # Task model
├── screens/                  # UI screens
│   ├── todo_list_screen.dart # Main todo list screen
│   └── counter_screen.dart   # Counter app screen
├── services/                 # External services
│   └── storage_service.dart  # Local storage service
├── widgets/                  # Reusable UI components
│   ├── task_item.dart       # Individual task widget
│   └── add_task_widget.dart # Add task input widget
└── main.dart                # App entry point
```

## 🎯 BLoC Pattern Implementation

### Task BLoC
The Task BLoC manages all task-related operations:

**Events:**
- `LoadTasks` - Load tasks from storage
- `AddTask` - Add a new task
- `ToggleTask` - Toggle task completion status
- `DeleteTask` - Delete a task
- `UpdateTask` - Update task details

**States:**
- `TaskInitial` - Initial state
- `TaskLoading` - Loading state
- `TaskLoaded` - Tasks loaded successfully
- `TaskError` - Error state with message
- `TaskSuccess` - Success state with message

### Counter BLoC
The Counter BLoC manages counter operations:

**Events:**
- `IncrementCounter` - Increment counter value
- `DecrementCounter` - Decrement counter value
- `ResetCounter` - Reset counter to zero

**States:**
- `CounterInitial` - Counter state with current value

## 🛠️ Technologies Used

- **Flutter** - UI framework
- **flutter_bloc** - State management library
- **equatable** - Value equality for immutable objects
- **shared_preferences** - Local data persistence
- **Material Design 3** - Modern UI components

## 📦 Installation

1. **Clone the repository:**
   ```bash
   git clone <repository-url>
   cd to_do_list_app
   ```

2. **Install dependencies:**
   ```bash
   flutter pub get
   ```

3. **Run the app:**
   ```bash
   flutter run
   ```

## 🎨 UI/UX Features

### Animations
- **Fade transitions** for task list loading
- **Scale animations** for counter interactions
- **Slide animations** for task items
- **Smooth transitions** between screens

### Design Elements
- **Material Design 3** components
- **Gradient backgrounds** for visual appeal
- **Card-based layouts** for content organization
- **Consistent color scheme** (Purple theme)
- **Responsive design** for different screen sizes

## 🔧 State Management Benefits

### Before BLoC (setState)
- ❌ Business logic mixed with UI code
- ❌ Difficult to test
- ❌ Hard to maintain and scale
- ❌ No separation of concerns

### After BLoC
- ✅ **Separation of Concerns** - Business logic separated from UI
- ✅ **Testability** - Easy to unit test business logic
- ✅ **Predictable State** - Immutable states with clear transitions
- ✅ **Reusability** - BLoCs can be reused across different widgets
- ✅ **Performance** - Efficient state updates with minimal rebuilds
- ✅ **Debugging** - Clear event flow and state changes

## 📱 App Screenshots



## 🧪 Testing

The BLoC pattern makes testing much easier:

```dart
// Example test for Task BLoC
test('should emit TaskLoaded when LoadTasks is added', () async {
  // Arrange
  final bloc = TaskBloc();
  
  // Act
  bloc.add(LoadTasks());
  
  // Assert
  await expectLater(
    bloc.stream,
    emitsInOrder([
      isA<TaskLoading>(),
      isA<TaskLoaded>(),
    ]),
  );
});
```

- [Material Design 3](https://m3.material.io/)

---

**Built with ❤️ using Flutter and BLoC**
