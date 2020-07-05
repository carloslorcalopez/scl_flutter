import 'package:mobx/mobx.dart';

part 'counter.g.dart';

class Counter = _Counter with _$Counter;

abstract class _Counter with Store {
  int limit = 5;
  @observable
  int count = 0;
 
//to identify counter state to provide appropriate message
 @observable
  int msgindicator = 0;
/*if we just want to compute something after action is performed we should use computed instead of observable */
  @computed
  String get msg => (msgindicator == 1)
      ? 'Sorry you reached upto $limit'
      : (msgindicator == 2) ? 'No negative value allowed' : '';

  @action
  void increment() {
    if (count < limit) {
      count++;
      msgindicator = 0;
    } else {
      msgindicator = 1;
    }
    print('increment $msgindicator');
  }

  @action
  void decrement() {
    if (count > 0) {
      count--;
      msgindicator = 0;
    } else {
      msgindicator = 2;
    }
  }

  @action
  void reset() {
    count = 0;
    msgindicator = 0;
  }
}