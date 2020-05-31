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

  ChuckInitialized(this.categories, this.search, this.jokes);

  @override
  List<Object> get props => [categories,search,jokes];
}

class ChuckLoading extends ChuckInitialized {
  ChuckLoading(List<String> categories, String search, List<ChuckResponse> jokes) : super(categories, search, jokes);
}
