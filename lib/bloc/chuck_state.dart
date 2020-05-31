part of 'chuck_bloc.dart';

abstract class ChuckState extends Equatable {
  const ChuckState();
}

class ChuckInitial extends ChuckState {
  @override
  List<Object> get props => [];
}

class ChuckInitialized extends ChuckState {
  final List<String> categories;
  final String search;
  final List<ChuckResponse> jokes;
  final String category;
  ChuckInitialized(this.categories, this.search, this.jokes, this.category);

  @override
  List<Object> get props => [categories,search,jokes,category];
}

class ChuckLoading extends ChuckInitialized {
  ChuckLoading(List<String> categories, String search, List<ChuckResponse> jokes, String category) : super(categories, search, jokes, category);
}
