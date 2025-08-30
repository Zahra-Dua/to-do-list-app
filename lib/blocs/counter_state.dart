// lib/blocs/counter_state.dart
import 'package:equatable/equatable.dart';

abstract class CounterState extends Equatable {
  const CounterState();

  @override
  List<Object?> get props => [];
}

class CounterInitial extends CounterState {
  final int count;

  const CounterInitial(this.count);

  @override
  List<Object?> get props => [count];

  CounterInitial copyWith({
    int? count,
  }) {
    return CounterInitial(
      count ?? this.count,
    );
  }
}
