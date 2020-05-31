import 'dart:async';

import 'package:chuck/chuckResponse.dart';
import 'package:chuck/chuckService.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ChuckPage extends StatefulWidget {
  ChuckPage({Key key}) : super(key: key);

  @override
  _ChuckPageState createState() => _ChuckPageState();
}

class _ChuckPageState extends State<ChuckPage> {
  List<String> categories = List<String>();
  List<ChuckResponse> jokes = List<ChuckResponse>();
  String dropdownValue;
  final ChuckService chuckService = ChuckService();
  ScrollController _controller = ScrollController();
  @override
  void initState() {
    categories.add('');
    chuckService.getCategories().then((value) {
      setState(() {
        categories.addAll(value);
      });
    });

    super.initState();
  }

  void _pushed() async {
    ChuckResponse response;
    if (dropdownValue != null && dropdownValue.isNotEmpty) {
      response = await chuckService.getJokeRandomByCategory(dropdownValue);
    } else {
      response = await chuckService.getJokeRandom();
    }
    setState(() {
      jokes.add(response);
    });
    Timer(Duration(milliseconds: 200),
        () => _controller.jumpTo(_controller.position.maxScrollExtent));
  }

  void _clear() {
    setState(() {
      jokes = List<ChuckResponse>();
      dropdownValue = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text('Chuck Norris App'),
        ),
        body: Center(
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
                            value: dropdownValue,
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
                              setState(() {
                                dropdownValue = newValue;
                              });
                            },
                            items: categories
                                .map<DropdownMenuItem<String>>((String value) {
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
                              child: FloatingActionButton(
                                onPressed: _pushed,
                                tooltip: 'Get Joke',
                                child: Icon(Icons.add),
                              ),
                              padding: EdgeInsets.all(10.0),
                            ),
                            Container(
                              child: FloatingActionButton(
                                onPressed: _clear,
                                tooltip: 'Get Joke',
                                child: Icon(Icons.delete),
                              ),
                              padding: EdgeInsets.all(10.0),
                            ),
                            Container(
                              child: Text(jokes.length.toString(),
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
                  itemCount: jokes.length,
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  controller: _controller,
                ),
              ),
            ],
          ),
        ));
  }

  Container buildList(BuildContext context, int position) {
    return Container( 
      padding: EdgeInsets.all(10),
      child: Row(
      children: <Widget>[
        Image.network(
          jokes[position].icon_url,
        ),
        Expanded(
          child: Card(
            child: Container(
                child: RichText(
                  text: TextSpan(
                    style: TextStyle(color: Colors.black),
                    children: <TextSpan>[
                      TextSpan(
                        text: '[ ' +
                            jokes[position].categories.toString() +
                            ' ] ',
                        style: TextStyle(
                            color: Colors.deepPurple, 
                            decoration: TextDecoration.none,
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      ),
                      TextSpan(
                        text: jokes[position].value,
                        style: TextStyle(
                            color: Colors.black,
                            decoration: TextDecoration.none,
                            fontSize: 18),
                      ),
                    ],
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
}
