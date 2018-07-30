import 'package:flutter/material.dart';
import 'dart:io';
import 'whois.dart';
import 'history.dart';

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
      home: Home(),
      theme: theme,
      title: 'whoisit',
    );
  }
}

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  @override
  HomeState createState() {
    return HomeState();
  }
}

class HomeState extends State<Home> {
  static final int _searchTab = 0;
  static final int _historyTab = 1;

  final TextEditingController _controller = TextEditingController();
  final HistorySet _history = HistorySet();

  Widget _searchChild = EmptySearchStatus();
  int _activeTab = _searchTab;

  set _child(Widget child) {
    if(_activeTab == _searchTab) {
      _searchChild = child;
    }
  }

  Widget get _child {
    if(_activeTab == _searchTab) {
      return _searchChild;
    }
    return _historyChild;
  }

  Widget get _historyChild {
    if(_history.length > 0) {
      return History(_history, onHistory);
    }
    return EmptyHistoryStatus();
  }

  Alignment get _alignment {
    if(_child is Status || _child is ProgressIndicator) {
      return Alignment.center;
    }
    return Alignment.topLeft;
  }

  void onSearch(String query) async {
    query = query.toLowerCase().trim();

    if(query.length > 0) {
      _activeTab = _searchTab;
      try {
        // Start the progress indicator
        setState(() {
          _child = CircularProgressIndicator();
        });

        // Wait for the response and update
        var whois = await Whois.query(query);
        setState(() {
          _child = Result(whois.response);
          _history.add(whois.domain.host);
        });
      } on FormatException {
        setState(() {
          _child = ErrorStatus('Invalid domain format');
        });
      } on SocketException {
        setState(() {
          _child = ErrorStatus('Invalid domain extension');
        });
      } on Exception {
        setState(() {
          _child = ErrorStatus('An unknown error occurred');
        });
      }
    }
  }

  void onNavigate(int tab) {
    if(_activeTab != tab) {
      setState(() => _activeTab = tab);
    }
  }

  void onHistory(String query) {
    setState(() => _controller.text = query);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Column(
        children: [
          SearchBar(
            controller: _controller,
            onSubmitted: onSearch,
          ),
          Expanded(
            child: Align(
              alignment: _alignment,
              child: _child,
            ),
          ),
        ],
      ),
      bottomNavigationBar: new BottomNavigationBar(
        currentIndex: _activeTab,
        onTap: onNavigate,
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
  ErrorStatus(String text) : super(
    icon: Icons.error,
    text: text,
  );
}

class EmptyHistoryStatus extends Status {
  EmptyHistoryStatus() : super(
    icon: Icons.info,
    text: 'Your search history is empty',
  );
}

class EmptySearchStatus extends Status {
  EmptySearchStatus() : super(
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
  final HistorySet history;
  final ValueSetter<String> onTap;

  History(this.history, this.onTap);

  @override
  Widget build(BuildContext context) {
    var widgets = <Widget>[];
    for(var domain in history) {
      widgets.add(
        ListTile(
          leading: Icon(Icons.restore),
          title: Text(domain),
          onTap: () => onTap(domain),
        )
      );
    }
    return Scrollbar(
      child: ListView(
        padding: EdgeInsets.all(0.0),
        children: widgets.reversed.toList(),
      ),
    );
  }
}

// Result displays a card containing plain text
class Result extends StatelessWidget {
  final String text;

  Result(this.text);

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
  final TextEditingController controller;
  final ValueChanged<String> onSubmitted;
  final double _padding = 10.0;

  SearchBar({@required this.controller, @required this.onSubmitted});

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
        top: _padding + MediaQuery.of(context).padding.top,
        bottom: _padding,
        left: _padding,
        right: _padding,
      ),
      child: Card(
        elevation: 2.0,
        child: TextField(
          autocorrect: false,
          controller: controller,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: 'Search',
            prefixIcon: Container(
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              child: const Icon(Icons.search),
            ),
          ),
          onSubmitted: onSubmitted,
        ),
      ),
    );
  }
}
