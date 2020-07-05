import 'package:chuck/chuckResponse.dart';
import 'package:chuck/chuckService.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mobx/mobx.dart';

part 'chuck.g.dart';

class Chuck = _Chuck with _$Chuck;
abstract class _Chuck with Store {
  final chuckService = ChuckService();
  @observable
  bool loading = false;
  @observable
  List<ChuckResponse> jokes = List();
  @observable
  String search = "";
  @observable
  String category = "";
  @observable
  List<String> categories;

  @action
  void getCategories() async {
    loading = true;
    categories = await chuckService.getCategories();
    loading = false;
  }

  @action
  getRandomJoke() async {
    loading = true;
    jokes.add(await chuckService.getJokeRandom());
    loading = false;
  }

  @action
  getJokeByCategory() async {
    loading = true;
    jokes.add(await chuckService.getJokeRandomByCategory(category));
    loading = false;
  }

  @action
  selectCategory(String selectedCategory) {
    this.category = selectedCategory;
  }

  @action
  doSearch(String searchAux) {
    this.search = searchAux;
  }

  List<TextSpan> formatText(ChuckResponse response) {
    List<TextSpan> salida = List<TextSpan>();
    salida.add(TextSpan(
      text: '[ ' + response.categories.toString() + ' ] ',
      style: TextStyle(
          color: Colors.deepPurple,
          decoration: TextDecoration.none,
          fontWeight: FontWeight.bold,
          fontSize: 18),
    ));
    for (String palabra in response.value.split(' ')) {
      if (palabra.compareTo(search) == 0) {
        salida.add(TextSpan(
          text: palabra + ' ',
          style: TextStyle(
              color: Colors.black,
              decoration: TextDecoration.underline,
              fontWeight: FontWeight.bold,
              fontSize: 18),
        ));
      } else {
        salida.add(TextSpan(
          text: palabra + ' ',
          style: TextStyle(
              color: Colors.black,
              decoration: TextDecoration.lineThrough,
              fontSize: 18),
        ));
      }
    }
    return salida;
  }

  @computed
  List<List<TextSpan>> get decored => jokes.map((e) => formatText(e)).toList();
}
