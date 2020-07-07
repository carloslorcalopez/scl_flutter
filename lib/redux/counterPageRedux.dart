import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import 'package:chuck/redux/counterState.dart';
import 'package:chuck/redux/counterActions.dart';
import 'counterReducer.dart';

class CounterPageRedux extends StatelessWidget {
  CounterPageRedux({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final store = new Store<CounterState>(
      counterStatereducer,
      initialState: new CounterState(0),
    );
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text('Flutter & Redux'),
      ),
      body: StoreProvider<CounterState>(
        store: store,
        child: Center(
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'You have pushed the button this many times:',
              ),
              StoreConnector<CounterState, String>(
                converter: (store) => store.state.counter.toString(),
                builder: (context, count) {
                  return Text(
                    count,
                    style: Theme.of(context).textTheme.display1,
                  );
                },
              ),
              StoreConnector<CounterState, VoidCallback>(
                converter: (store) {
                  // Return a `VoidCallback`, which is a fancy name for a function
                  // with no parameters. It only dispatches an Increment action.
                  return () => store.dispatch(IncrementAction);
                },
                builder: (context, callback) {
                  return FloatingActionButton(
                    // Attach the `callback` to the `onPressed` attribute
                    onPressed: callback,
                    tooltip: 'asdasdasd',
                    child: Icon(Icons.add),
                    heroTag: 'add',
                  );
                },
              ), // This trailing comma makes auto-formatting nicer for build methods.
              StoreConnector<CounterState, VoidCallback>(
                converter: (store) {
                  // Return a `VoidCallback`, which is a fancy name for a function
                  // with no parameters. It only dispatches an Increment action.
                  return () => store.dispatch(DecrementAction);
                },
                builder: (context, callback) {
                  return FloatingActionButton(
                    // Attach the `callback` to the `onPressed` attribute
                    onPressed: callback,
                    tooltip: 'asdasdasd',
                    child: Icon(Icons.delete),
                    heroTag: 'minus',
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
