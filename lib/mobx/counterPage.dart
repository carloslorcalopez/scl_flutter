import 'package:flutter/material.dart';
import 'package:chuck/mobx/store.counter/counter.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class CounterPageMobx extends StatefulWidget {
  @override
  CounterPageState createState() {
    return CounterPageState();
  }
}

class CounterPageState extends State<CounterPageMobx> {
  final counter = Counter();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Flutter & MobX'),
        ),
        body: Center(child: Observer(builder: (_) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('Counter', style: TextStyle(fontSize: 30)),
              Text(counter.count.toString(), style: TextStyle(fontSize: 30)),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FlatButton.icon(
                      icon: Icon(Icons.add),
                      label: Text('Add'),
                      color: Colors.green,
                      onPressed: counter.increment,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FlatButton.icon(
                      icon: Icon(Icons.remove),
                      label: Text('Minus'),
                      onPressed: counter.decrement,
                      color: Colors.deepOrangeAccent,
                    ),
                  ),
                ],
              ),
              Text('message for overflow and underflow'),
              FlatButton.icon(
                icon: Icon(Icons.reply),
                label: Text('Reset'),
                color: Colors.red,
                onPressed: counter.reset,
              ),
            ],
          );
        })));
  }
}
