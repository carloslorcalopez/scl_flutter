import 'package:chuck/chuckResponse.dart';

class DoGetCategories {
  final List<String> categories;

  DoGetCategories(this.categories);
}

class Loading {}

class FinishLoading{}

class DoGetJoke {
  final ChuckResponse response;
  DoGetJoke(
    this.response
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
