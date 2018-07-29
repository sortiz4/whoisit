import 'package:flutter/material.dart';

void main() {
  runApp(App());
}

class AppTheme {
  static final backgroundColor = const Color(0xFFEEEEEE);
  static final primaryColor = const Color(0xFF007DE6);
  static final shadowColor = const Color(0x33000000);

  static final light = ThemeData(
    backgroundColor: backgroundColor,
    primaryColor: primaryColor,
    accentColor: primaryColor,
  );
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
      title: 'whoisit',
      theme: AppTheme.light,
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Column(
        children: [
          SearchBar(),
          Expanded(
            child: Center(
              child: DefaultStatus(),
              // child: Result(),
            ),
          ),
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
    );
  }
}

class ErrorStatus extends Status {
  ErrorStatus({String text}) : super(
    icon: Icons.error,
    text: text,
  );
}

class DefaultStatus extends Status {
  DefaultStatus() : super(
    icon: Icons.search,
    text: 'Search for something...',
  );
}

// Status displays an icon and a message
class Status extends StatelessWidget {
  final IconData icon;
  final String text;

  Status({this.icon, this.text});

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: 0.5,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(8.0),
            child: Icon(
              icon,
              size: Theme.of(context).textTheme.display2.fontSize,
              color: Theme.of(context).textTheme.body2.color,
            ),
          ),
          Text(
            text,
            style: Theme.of(context).textTheme.body2,
          ),
        ],
      ),
    );
  }
}

// Result displays a card containing plain text
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
            color: AppTheme.shadowColor,
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
