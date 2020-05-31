import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:chuck/chuckResponse.dart';
import 'package:chuck/chuckService.dart';
import 'package:equatable/equatable.dart';

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
      yield ChuckInitialized(categories, '', List<ChuckResponse>());
    }
  }
}
