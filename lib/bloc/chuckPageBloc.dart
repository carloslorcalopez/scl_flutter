import 'dart:async';

import 'package:chuck/bloc/chuck_bloc.dart';
import 'package:chuck/chuckResponse.dart';
import 'package:chuck/chuckService.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChuckPageBloc extends StatefulWidget {
  ChuckPageBloc({Key key}) : super(key: key);

  @override
  _ChuckPageBlocState createState() => _ChuckPageBlocState();
}

class _ChuckPageBlocState extends State<ChuckPageBloc> {
  ChuckBloc bloc = ChuckBloc();
  ScrollController _controller = ScrollController();
  @override
  void initState() {
    bloc.add(AppStarted());
    bloc.listen((value) {
      if (value is ChuckInitialized)
        Timer(Duration(milliseconds: 200),
            () => _controller.jumpTo(_controller.position.maxScrollExtent));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text('Chuck Norris App - BLOC'),
        ),
        body: BlocBuilder<ChuckBloc, ChuckState>(
            bloc: bloc,
            builder: (BuildContext context, ChuckState state) {
              if (state is ChuckInitial) {
                return CircularProgressIndicator();
              } else {
                ChuckInitialized stateInit = state as ChuckInitialized;
                Widget buttonGetJoke;
                Widget buttonGetDelete;
                if (state is ChuckLoading) {
                  buttonGetJoke = CircularProgressIndicator();
                  buttonGetDelete = CircularProgressIndicator();
                } else {
                  buttonGetJoke = FloatingActionButton(
                    onPressed: () => bloc.add(DoGetJokes()),
                    tooltip: 'Get Joke',
                    child: Icon(Icons.add),
                  );
                  buttonGetDelete = FloatingActionButton(
                    onPressed: () => bloc.add(DoDelete(null)),
                    tooltip: 'Get Joke',
                    child: Icon(Icons.delete),
                  );
                }
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        child: Card(
                          child: Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  padding: EdgeInsets.all(15),
                                  child: DropdownButton<String>(
                                    value: stateInit.category,
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
                                      bloc.add(SelectCategory(newValue));
                                    },
                                    items: stateInit.categories
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
                                      child: Text(
                                          stateInit.jokes.length.toString(),
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
                          itemCount: stateInit.jokes.length,
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          controller: _controller,
                        ),
                      ),
                    ],
                  ),
                );
              }
            }));
  }

  Container buildList(BuildContext context, int position) {
    ChuckInitialized state = bloc.state as ChuckInitialized;
    return Container(
        padding: EdgeInsets.all(10),
        child: Row(
          children: <Widget>[
            Column(
              children: <Widget>[
                Image.network(
                  state.jokes[position].icon_url,
                ),
                FloatingActionButton(
                  tooltip: 'Get Joke',
                  child: Icon(Icons.delete),
                  onPressed: () => bloc.add(DoDelete(state.jokes[position].id)),
                  mini: true,
                ),
              ],
            ),
            Expanded(
              child: Card(
                child: Container(
                    child: RichText(
                      text: TextSpan(
                        style: TextStyle(color: Colors.black),
                        children:
                            formatText(state.jokes[position], state.search),
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
