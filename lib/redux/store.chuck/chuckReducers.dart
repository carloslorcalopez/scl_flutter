import 'package:chuck/redux/store.chuck/chuckActions.dart';
import 'package:chuck/redux/store.chuck/chuckState.dart';
import 'package:flutter/widgets.dart';

ChuckState chuckReducers(ChuckState prev, dynamic action) {
  if (action is DoGetCategories) {
    debugPrint('reducer');
    List<String> catAux = List();
    catAux.add('');
    catAux.addAll((action as DoGetCategories).categories);
    return ChuckState(false, List(), '', '', catAux, true);
  }
}
