import 'package:chuck/chuckResponse.dart';
import 'package:mobx/mobx.dart';

abstract class _Chuck with Store {
  @observable
  bool loading = false;
  @observable
  ObservableFuture<List<ChuckResponse>> jokes;
  @observable
  String search = "";
  @observable
  String category = "";
  @observable
  List<String> categories = List();

}