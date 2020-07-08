import 'package:chuck/chuckService.dart';
import 'package:chuck/redux/store.chuck/chuckActions.dart';
import 'package:chuck/redux/store.chuck/chuckState.dart';
import 'package:flutter/rendering.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';

ThunkAction<ChuckState> getCategories() {
  ChuckService chuckService = new ChuckService();
  return (Store<ChuckState> store) async {
    new Future(() async {
      store.dispatch(DoGetCategories(await chuckService.getCategories()));
    });
  };
}

ThunkAction<ChuckState> getJoke() {
  ChuckService chuckService = new ChuckService();
  
  debugPrint('Loading dispatch');
  return (Store<ChuckState> store) async {
    store.dispatch(Loading());
    new Future(() async {
      try{
      if (store.state.category != null && store.state.category.isNotEmpty) {
        store.dispatch(DoGetJoke(await chuckService.getJokeRandomByCategory(store.state.category)));
      } else {
        store.dispatch(DoGetJoke(await chuckService.getJokeRandom()));
      }
      } on Exception catch (exception) {
        debugPrint(exception.toString());
        store.dispatch(FinishLoading());
      }
    });
  };
}
