import 'package:chuck/chuckResponse.dart';
import 'package:chuck/redux/store.chuck/chuckState.dart';

class DoGetCategories {
  final List<String> categories;

  DoGetCategories(this.categories);
}

class Loading {}

class DoGetJoke {
  final ChuckResponse response;
  final ChuckState prev;
  DoGetJoke(
    this.response,
    this.prev,
  );
}

class DoDelete {
  final String id;

  DoDelete(this.id);
}

class DoSelectCategory {
  final String id;

  DoSelectCategory(this.id);
}

class DoSearch {
  final String search;

  DoSearch(this.search);
}
