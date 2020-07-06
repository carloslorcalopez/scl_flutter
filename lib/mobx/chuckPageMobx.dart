import 'dart:async';

import 'package:chuck/mobx/store.chuck/chuck.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';

class ChuckPageMobx extends StatefulWidget {
  ChuckPageMobx({Key key}) : super(key: key);

  @override
  _ChuckPageMobxState createState() => _ChuckPageMobxState();
}

class _ChuckPageMobxState extends State<ChuckPageMobx> {
  final chuck = Chuck();
  ScrollController _controller = ScrollController();
  var textController = new TextEditingController();

  @override
  void initState() {
    chuck.doGetCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text('Chuck APP - MOBX'),
        ),
        body: Observer(builder: (_) {
          if (!chuck.initalized) {
            return CircularProgressIndicator();
          } else {
            Widget buttonGetJoke;
            Widget buttonGetDelete;
            if (chuck.loading) {
              buttonGetJoke = CircularProgressIndicator();
              buttonGetDelete = CircularProgressIndicator();
            } else {
              buttonGetJoke = FloatingActionButton(
                onPressed: () => chuck.getJokeByCategory(),
                tooltip: 'Get Joke',
                child: Icon(Icons.add),
                heroTag: 'getJoke',
              );
              buttonGetDelete = FloatingActionButton(
                onPressed: () {
                  chuck.doDelete(null);
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
                      chuck.doSearch(value);
                    },
                    controller: textController,
                  ),
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
                                value: chuck.category,
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
                                  chuck.selectCategory(newValue);
                                },
                                items: chuck.categories
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
                                  child: Text(chuck.jokes.length.toString(),
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
                      itemCount: chuck.jokes.length,
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
    Timer(Duration(milliseconds: 300),
            () => _controller.jumpTo(_controller.position.maxScrollExtent));
    return Container(
        padding: EdgeInsets.all(10),
        child: Row(
          children: <Widget>[
            Column(
              children: <Widget>[
                Image.network(
                  chuck.jokes[position].icon_url,
                ),
                FloatingActionButton(
                  tooltip: 'Get Joke',
                  child: Icon(Icons.delete),
                  onPressed: () => chuck.doDelete(chuck.jokes[position].id),
                  mini: true,
                  heroTag: chuck.jokes[position].id,
                ),
              ],
            ),
            Expanded(
              child: Card(
                child: Container(
                    child: RichText(
                      text: TextSpan(
                          style: TextStyle(color: Colors.black),
                          children: chuck.decored[position]),
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
}
