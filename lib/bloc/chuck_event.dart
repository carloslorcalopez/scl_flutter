part of 'chuck_bloc.dart';

abstract class ChuckEvent extends Equatable {
  const ChuckEvent();
}

class AppStarted extends ChuckEvent {
  @override
  List<Object> get props => [];
}

class DoGetJokes extends ChuckEvent {
  
  @override
  List<Object> get props => [];
}

class DoDelete extends ChuckEvent {
  final String id;

  DoDelete(this.id);
  @override
  List<Object> get props => [id];
}

class DoSearch extends ChuckEvent {
  final String search;

  DoSearch(this.search);
  @override
  List<Object> get props => [search];
}

class SelectCategory extends ChuckEvent {
  final String category;

  SelectCategory(this.category);

  @override
  List<Object> get props => [category];
}