import 'package:chuck/chuckService.dart';
import 'package:chuck/redux/store.chuck/chuckActions.dart';
import 'package:chuck/redux/store.chuck/chuckState.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';

ThunkAction<ChuckState> getCategories() {
  ChuckService chuckService = new ChuckService();
  return (Store<ChuckState> store) async {
    new Future(() async{
      chuckService.getCategories().then((value) => store.dispatch(DoGetCategories(value)));
      
    });
    
  };
}