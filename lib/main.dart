import 'package:flutter/material.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
      color: const Color(0xFF007DE6),
      title: 'whoisit',
    );
  }
}

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  HomePageState createState() {
    return HomePageState();
  }
}

class HomePageState extends State<HomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() => _counter++);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        // Contents of the column must be reversed to cast a shadow
        verticalDirection: VerticalDirection.up,
        children: [
          Expanded(
            child: Container(
              color: const Color(0xFFEEEEEE),
              child: Center(
                child: Default(counter: _counter),
              ),
            ),
          ),
          SearchBar(),
        ],
      ),
      bottomNavigationBar: new BottomNavigationBar(
        items: [
          new BottomNavigationBarItem(
            icon: const Icon(Icons.search),
            title: new Text('Search'),
          ),
          new BottomNavigationBarItem(
            icon: const Icon(Icons.history),
            title: new Text('History'),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}

class Default extends StatelessWidget {
  final int counter;

  Default({this.counter});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'You have pushed the button this many times:',
        ),
        Text(
          '$counter',
          style: Theme.of(context).textTheme.display1,
        ),
      ],
    );
  }
}

class Result extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          margin: EdgeInsets.all(10.0),
          child: Align(
            alignment: Alignment.topLeft,
            child: Text('test'),
          ),
        ),
      ],
    );
  }
}

class SearchBar extends StatelessWidget {
  final double _horizontalPadding = 10.0;
  final double _verticalPadding = 15.0;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        boxShadow: [
          BoxShadow(
            color: const Color(0x33000000),
            blurRadius: 1.0,
            spreadRadius: 1.0,
          ),
        ],
      ),
      padding: EdgeInsets.only(
        top: _verticalPadding + MediaQuery.of(context).padding.top,
        bottom: _verticalPadding,
        left: _horizontalPadding,
        right: _horizontalPadding,
      ),
      child: Search(),
    );
  }
}

class Search extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2.0,
      child: TextField(
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: 'Search',
          prefixIcon: Container(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: const Icon(Icons.search),
          ),
        ),
      ),
    );
  }
}
