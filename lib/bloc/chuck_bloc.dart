import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:chuck/chuckResponse.dart';
import 'package:chuck/chuckService.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

part 'chuck_event.dart';
part 'chuck_state.dart';

class ChuckBloc extends Bloc<ChuckEvent, ChuckState> {
  @override
  ChuckState get initialState => ChuckInitial();

  @override
  Stream<ChuckState> mapEventToState(
    ChuckEvent event,
  ) async* {
    // TODO: implement mapEventToState
    if (event is AppStarted) {
      List<String> categories = List<String>();
      categories.add('');
      categories.addAll(await ChuckService().getCategories());
      yield ChuckInitialized(categories, '', List<ChuckResponse>(), '');
    }
    if (event is DoGetJokes) {
      ChuckInitialized current = this.state as ChuckInitialized;
      yield ChuckLoading(
          current.categories, current.search, current.jokes, current.category);
      if (current.category != null && current.category != '') {
        try {
          current.jokes.add(
              await ChuckService().getJokeRandomByCategory(current.category));
        } on Exception catch (exception) {
          debugPrint(exception.toString());
          yield (this.state);
        }
      } else {
        try {
          current.jokes.add(await ChuckService().getJokeRandom());
        } on Exception catch (exception) {
          debugPrint(exception.toString());
          yield (this.state);
        }
      }
      yield ChuckInitialized(
          current.categories, current.search, current.jokes, current.category);
    }
    if (event is SelectCategory) {
      ChuckInitialized current = this.state as ChuckInitialized;
      yield ChuckInitialized(
          current.categories, current.search, current.jokes, event.category);
    }
    if (event is DoSearch) {
      ChuckInitialized current = this.state as ChuckInitialized;
      yield ChuckInitialized(
          current.categories, event.search, current.jokes, current.category);
    }
    if (event is DoDelete) {
      if (event.id != null && event.id.length > 0) {
      } else {
        ChuckInitialized current = this.state as ChuckInitialized;
        yield ChuckInitialized(
            current.categories, null, List<ChuckResponse>(), null);
      }
    }
  }
}
