import 'package:chuck/chuckResponse.dart';
import 'package:chuck/redux/store.chuck/chuckActions.dart';
import 'package:chuck/redux/store.chuck/chuckState.dart';
import 'package:flutter/widgets.dart';

ChuckState chuckReducers(ChuckState prev, dynamic action) {
  if (action is DoGetJoke) {
    debugPrint('reducer getJoke');
    List<ChuckResponse> jokesAux = prev.jokes;
    jokesAux.add(action.response);
    return ChuckState(false, jokesAux, prev.search, prev.category,
        prev.categories, true);
  }

  if (action is Loading) {
    debugPrint('Reducer Loading');
    return ChuckState(
        true, prev.jokes, prev.search, prev.category, prev.categories, true);
  }

    if (action is FinishLoading) {
    debugPrint('Reducer FinishLoading');
    return ChuckState(
        false, prev.jokes, prev.search, prev.category, prev.categories, true);
  }

  if (action is DoDelete) {
    if (action.id != null && action.id.length > 0) {
      return ChuckState(
          false, prev.jokes, prev.search, prev.category, prev.categories, true);
    } else {
      return ChuckState(false, List(), '', '', prev.categories, true);
    }
  }

  if (action is DoSelectCategory) {
    return ChuckState(
        false, prev.jokes, prev.search, action.id, prev.categories, true);
  }

  if (action is DoSearch) {
    return ChuckState(
        false, prev.jokes, action.search, prev.category, prev.categories, true);
  }
  debugPrint('Prev State: ' + prev.toString());
  return prev;
}

ChuckState chuckDoGetCategories(ChuckState prev, DoGetCategories action) {
  debugPrint('reducer categories');
  List<String> catAux = List();
  catAux.add('');
  catAux.addAll(action.categories);
  return ChuckState(false, List(), '', '', catAux, true);
}
