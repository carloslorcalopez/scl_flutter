import 'counterState.dart';
import 'counterActions.dart';

CounterState counterStatereducer(CounterState prev, dynamic action) {
  if (action == IncrementAction) {
    CounterState newAppState = new CounterState(prev.counter + 1);

    return newAppState;
  } else if (action == DecrementAction) {
    if (prev.counter > 0) {
      return new CounterState(prev.counter - 1);
    } else {
      return prev;
    }
  } else {
    return prev;
  }
}
