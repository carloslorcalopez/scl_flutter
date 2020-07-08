import 'dart:async';

import 'package:chuck/chuckResponse.dart';
import 'package:chuck/redux/store.chuck/chuckActions.dart';
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
    combineReducers<ChuckState>([
      TypedReducer<ChuckState, dynamic>(chuckReducers),
      TypedReducer<ChuckState, DoGetCategories>(chuckDoGetCategories)
    ]),
    initialState: ChuckState(false, List(), '', '', List(), false, false),
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
    return StoreProvider<ChuckState>(
      store: store,
      child: Scaffold(
          appBar: AppBar(
              // Here we take the value from the MyHomePage object that was created by
              // the App.build method, and use it to set our appbar title.
              title: StoreConnector<ChuckState, ChuckState>(
            converter: (store) => store.state,
            builder: (context, state) {
              if (store.state.networkError) {
                return Text('Chuck APP - REDUX - NETWORK ERROR');
              } else {
                return Text('Chuck APP - REDUX');
              }
            },
          )),
          body: StoreConnector<ChuckState, ChuckState>(
              converter: (store) => store.state,
              builder: (context, state) {
                if (state == null) {
                  return CircularProgressIndicator();
                }
                if (!state.initalized) {
                  return CircularProgressIndicator();
                } else {
                  Widget buttonGetJoke;
                  Widget buttonGetDelete;
                  if (state.loading) {
                    buttonGetJoke = CircularProgressIndicator();
                    buttonGetDelete = CircularProgressIndicator();
                  } else {
                    buttonGetJoke = FloatingActionButton(
                      onPressed: () {
                        store.dispatch(getJoke());
                      },
                      tooltip: 'Get Joke',
                      child: Icon(Icons.add),
                      heroTag: 'getJoke',
                    );
                    buttonGetDelete = FloatingActionButton(
                      onPressed: () {
                        store.dispatch(DoDelete(null));
                        textController.text = '';
                      },
                      tooltip: 'Get Joke',
                      child: Icon(Icons.delete),
                      heroTag: 'DeleteAll',
                    );
                  }
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        TextField(
                          onChanged: (value) {
                            store.dispatch(DoSearch(value));
                          },
                          controller: textController,
                        ),
                        Container(
                          child: Card(
                            child: Container(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                    padding: EdgeInsets.all(15),
                                    child: DropdownButton<String>(
                                      value: state.category,
                                      icon: Icon(Icons.arrow_downward),
                                      iconSize: 24,
                                      elevation: 16,
                                      style: TextStyle(
                                          color: Colors.deepPurple,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                      underline: Container(
                                        height: 2,
                                        color: Colors.deepPurpleAccent,
                                      ),
                                      onChanged: (String newValue) {
                                        store.dispatch(
                                            DoSelectCategory(newValue));
                                      },
                                      items: state.categories
                                          .map<DropdownMenuItem<String>>(
                                              (String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Container(
                                        child: buttonGetJoke,
                                        padding: EdgeInsets.all(10.0),
                                      ),
                                      Container(
                                        child: buttonGetDelete,
                                        padding: EdgeInsets.all(10.0),
                                      ),
                                      Container(
                                        child:
                                            Text(state.jokes.length.toString(),
                                                style: TextStyle(
                                                  color: Colors.blueGrey[800],
                                                  fontSize: 30,
                                                  fontWeight: FontWeight.bold,
                                                )),
                                        padding: EdgeInsets.all(10.0),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            elevation: 10,
                            margin: EdgeInsets.all(4.0),
                          ),
                          margin: EdgeInsets.all(10.0),
                        ),
                        Expanded(
                          child: ListView.builder(
                            itemBuilder: (context, position) =>
                                buildList(context, position),
                            itemCount: state.jokes.length,
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            controller: _controller,
                          ),
                        ),
                      ],
                    ),
                  );
                }
              })),
    );
  }

  Container buildList(BuildContext context, int position) {
    Timer(Duration(milliseconds: 300),
        () => _controller.jumpTo(_controller.position.maxScrollExtent));
    return Container(
        padding: EdgeInsets.all(10),
        child: Row(
          children: <Widget>[
            Column(
              children: <Widget>[
                Image.network(
                  store.state.jokes[position].icon_url,
                ),
                FloatingActionButton(
                  tooltip: 'Get Joke',
                  child: Icon(Icons.delete),
                  onPressed: () =>
                      store.dispatch(DoDelete(store.state.jokes[position].id)),
                  mini: true,
                  heroTag: store.state.jokes[position].id,
                ),
              ],
            ),
            Expanded(
              child: Card(
                child: Container(
                    child: RichText(
                      text: TextSpan(
                        style: TextStyle(color: Colors.black),
                        children: formatText(
                            store.state.jokes[position], store.state.search),
                      ),
                    ),
                    padding: EdgeInsets.all(4.0)),
                borderOnForeground: true,
                elevation: 6,
                color: Colors.blue[50],
              ),
            ),
          ],
          verticalDirection: VerticalDirection.down,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
        ));
  }

  List<TextSpan> formatText(ChuckResponse response, String search) {
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
              decoration: TextDecoration.none,
              fontSize: 18),
        ));
      }
    }
    return salida;
  }
}
