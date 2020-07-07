import 'package:chuck/redux/store.chuck/chuckReducers.dart';
import 'package:chuck/redux/store.chuck/chuckState.dart';
import 'package:chuck/redux/store.chuck/chuckThunk.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';

class ChuckPageRedux extends StatefulWidget {
  ChuckPageRedux({Key key}) : super(key: key);

  @override
  _ChuckPageReduxState createState() => _ChuckPageReduxState();
}

class _ChuckPageReduxState extends State<ChuckPageRedux> {
  final store = new Store<ChuckState>(
    chuckReducers,
    initialState: ChuckState(false, List(), '', '', List(), false),
    middleware: [
      thunkMiddleware, // Add to middlew
    ],
  );
  ScrollController _controller = ScrollController();
  var textController = new TextEditingController();

  @override
  void initState() {
    debugPrint('Init state Redux');
    store.dispatch(getCategories());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text('Chuck APP - REDUX'),
        ),
        body: StoreProvider<ChuckState>(
            store: store,
            child: StoreConnector<ChuckState, bool>(
                converter: (store) => store.state.initalized,
                builder: (context, init) {
                  if (!init) {
                    return CircularProgressIndicator();
                  } else {
                    return Text(
                      'Cargado',
                      style: Theme.of(context).textTheme.display1,
                    );
                  }
                })));
  }
}
