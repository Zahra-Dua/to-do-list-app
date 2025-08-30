// test/bloc_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:to_do_list_app/blocs/counter_bloc.dart';
import 'package:to_do_list_app/blocs/counter_event.dart';
import 'package:to_do_list_app/blocs/counter_state.dart';

void main() {
  group('CounterBloc', () {
    test('initial state is CounterInitial with count 0', () {
      expect(CounterBloc().state, equals(CounterInitial(0)));
    });

    blocTest<CounterBloc, CounterState>(
      'emits CounterInitial with count 1 when IncrementCounter is added',
      build: () => CounterBloc(),
      act: (bloc) => bloc.add(IncrementCounter()),
      expect: () => [CounterInitial(1)],
    );

    blocTest<CounterBloc, CounterState>(
      'emits CounterInitial with count -1 when DecrementCounter is added',
      build: () => CounterBloc(),
      act: (bloc) => bloc.add(DecrementCounter()),
      expect: () => [CounterInitial(-1)],
    );

    blocTest<CounterBloc, CounterState>(
      'emits CounterInitial with count 0 when ResetCounter is added',
      build: () => CounterBloc(),
      act: (bloc) => bloc.add(ResetCounter()),
      expect: () => [CounterInitial(0)],
    );

    blocTest<CounterBloc, CounterState>(
      'emits correct states for multiple operations',
      build: () => CounterBloc(),
      act: (bloc) {
        bloc.add(IncrementCounter());
        bloc.add(IncrementCounter());
        bloc.add(DecrementCounter());
        bloc.add(ResetCounter());
      },
      expect: () => [
        CounterInitial(1),
        CounterInitial(2),
        CounterInitial(1),
        CounterInitial(0),
      ],
    );
  });
}
