import 'package:flutter/material.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  static final backgroundColor = const Color(0xFFEEEEEE);
  static final primaryColor = const Color(0xFF007DE6);
  static final shadowColor = const Color(0x33000000);

  static final theme = ThemeData(
    backgroundColor: backgroundColor,
    primaryColor: primaryColor,
    accentColor: primaryColor,
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
      title: 'whoisit',
      theme: theme,
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
            child: Align(
              alignment: Alignment.topLeft,
//                child: Result(),
                child: History(),
            ),
//            child: Center(
//              child: DefaultStatus(),
//            ),
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

class History extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      child: ListView(
        padding: EdgeInsets.all(0.0),
        children: [
          ListTile(
            leading: Icon(Icons.replay),
            title: Text('google.com'),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}

// Result displays a card containing plain text
class Result extends StatelessWidget {
  final String text;

  Result({this.text});

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      child: SingleChildScrollView(
        child: Card(
          elevation: 2.0,
          margin: EdgeInsets.all(10.0),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[800],
                ),
                padding: EdgeInsets.all(10.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Response',
                    style: Theme.of(context).textTheme.button.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(10.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Scrollbar(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Text(
                        text ?? 'test\n1234\nasdf',
                        style: TextStyle(
                          fontFamily: 'RobotoMono',
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
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
            color: App.shadowColor,
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
