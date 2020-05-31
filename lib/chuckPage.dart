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
  @override
  void initState() {
    chuckService.getCategories().then((value) {
      categories = value;
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
  }

  void _clear() {
    setState(() {
      jokes = List<ChuckResponse>();
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
          // Center is a layout widget. It takes a single child and positions it
          // in the middle of the parent.
          child: Column(
            // Column is also a layout widget. It takes a list of children and
            // arranges them vertically. By default, it sizes itself to fit its
            // children horizontally, and tries to be as tall as its parent.
            //
            // Invoke "debug painting" (press "p" in the console, choose the
            // "Toggle Debug Paint" action from the Flutter Inspector in Android
            // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
            // to see the wireframe for each widget.
            //
            // Column has various properties to control how it sizes itself and
            // how it positions its children. Here we use mainAxisAlignment to
            // center the children vertically; the main axis here is the vertical
            // axis because Columns are vertical (the cross axis would be
            // horizontal).
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  DropdownButton<String>(
                    value: dropdownValue,
                    icon: Icon(Icons.arrow_downward),
                    iconSize: 24,
                    elevation: 16,
                    style: TextStyle(color: Colors.deepPurple),
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
                  FloatingActionButton(
                    onPressed: _pushed,
                    tooltip: 'Get Joke',
                    child: Icon(Icons.add),
                  ),
                  FloatingActionButton(
                    onPressed: _clear,
                    tooltip: 'Get Joke',
                    child: Icon(Icons.delete),
                  ),
                ],
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: ListView.builder(
                    itemBuilder: (context, position) =>
                        buildList(context, position),
                    itemCount: jokes.length,
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  Row buildList(BuildContext context, int position) {
    return Row(
      children: <Widget>[
        Image.network(
          jokes[position].icon_url,
        ),
        Expanded(
          child: Card(
            child: Container(
                child: Text(
                  jokes[position].value,
                  overflow: TextOverflow.fade,
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.left,
                ),
                padding: EdgeInsets.all(4.0)),
            borderOnForeground: true,
            elevation: 6,
          ),
        ),
      ],
      verticalDirection: VerticalDirection.down,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
    );
  }
}
