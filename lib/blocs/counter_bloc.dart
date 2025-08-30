// lib/blocs/counter_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'counter_event.dart';
import 'counter_state.dart';

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

  void _onDecrementCounter(DecrementCounter event, Emitter<CounterState> emit) {
    final currentState = state;
    if (currentState is CounterInitial) {
      emit(CounterInitial(currentState.count - 1));
    }
  }

  void _onResetCounter(ResetCounter event, Emitter<CounterState> emit) {
    emit(CounterInitial(0));
  }
}
