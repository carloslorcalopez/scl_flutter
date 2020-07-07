import 'package:chuck/chuckService.dart';
import 'package:chuck/redux/store.chuck/chuckActions.dart';
import 'package:chuck/redux/store.chuck/chuckState.dart';
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

ThunkAction<ChuckState> getJoke(String categoryAux,ChuckState prev) {
  ChuckService chuckService = new ChuckService();
  return (Store<ChuckState> store) async {
    store.dispatch(Loading);
    new Future(() async {
      if (categoryAux != null && categoryAux.isNotEmpty) {
        store.dispatch(DoGetJoke(await chuckService.getJokeRandomByCategory(categoryAux),prev));
      } else {
        store.dispatch(DoGetJoke(await chuckService.getJokeRandom(),prev));
      }
    });
  };
}
