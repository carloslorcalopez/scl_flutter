import 'package:chuck/chuckResponse.dart';

class ChuckState {
  final bool loading;

  final List<ChuckResponse> jokes;

  final String search;

  final String category;

  final List<String> categories;

  final bool initalized;

  final bool networkError;

  ChuckState(this.loading, this.jokes, this.search, this.category, this.categories, this.initalized, this.networkError);
}