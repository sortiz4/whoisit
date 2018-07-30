import 'dart:io';
import 'package:flutter/material.dart';
import 'package:whoisit/history.dart';
import 'package:whoisit/whois.dart';
import 'package:whoisit/widgets/history.dart';
import 'package:whoisit/widgets/response.dart';
import 'package:whoisit/widgets/search.dart';
import 'package:whoisit/widgets/status.dart';

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
          _child = Response(whois.response);
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
