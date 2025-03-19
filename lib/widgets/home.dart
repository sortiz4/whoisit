import 'dart:io';
import 'package:flutter/material.dart';
import 'package:whoisit/history.dart';
import 'package:whoisit/whois.dart';
import 'package:whoisit/widgets/history.dart';
import 'package:whoisit/widgets/search.dart';
import 'package:whoisit/widgets/status.dart';
import 'package:whoisit/widgets/whois.dart';

/// The home widget is the single source of truth and orchestrates important
/// behaviors such as tab navigation, history management, and search queries.
class Home extends StatefulWidget {
  final History history;

  Home({required this.history});

  @override
  _HomeState createState() {
    return _HomeState();
  }
}

class _HomeState extends State<Home> {
  /// A constant representing the search tab index.
  static final _searchTab = 0;

  /// A constant representing the history tab index.
  static final _historyTab = 1;

  /// The search controller is passed down to the search bar. The contents will
  /// be overwritten when a user recalls a query from their search history.
  final _searchController = TextEditingController();

  /// The search view displays a status indicator or a successful WHOIS query
  /// response. The initial view directs the user to search for something.
  Widget _searchView = EmptySearchStatus();

  /// The active tab index applies to the bottom navigation bar.
  int _activeTab = _searchTab;

  /// The user's search history will be updated upon successful WHOIS queries.
  History get _history {
    return widget.history;
  }

  /// The view getter returns the view associated with the active tab.
  Widget get _view {
    return _activeTab == _searchTab ? (
      _searchView
    ) : (
      _historyView
    );
  }

  /// The view setter only applies when the search tab is active.
  set _view(Widget child) {
    if (_activeTab == _searchTab) {
      _searchView = child;
    }
  }

  /// The history view will only display a non-empty search history. Otherwise,
  /// a status indicator will be displayed revealing an empty search history.
  Widget get _historyView {
    return _history.length != 0 ? (
      HistoryView(history: _history, onTap: onRecall)
    ) : (
      EmptyHistoryStatus()
    );
  }

  /// View alignment is determined by the type of view. Status and progress
  /// indicators are centered - all other views are top-left justified.
  Alignment get _alignment {
    return _view is Status || _view is ProgressIndicator ? (
      Alignment.center
    ) : (
      Alignment.topLeft
    );
  }

  /// Automatically switches to the search tab and executes a WHOIS query if
  /// the query is non-empty (all queries will be trimmed and normalized). A
  /// response card will be displayed upon a successful query, otherwise a
  /// status indicator will be displayed revealing the type of error. Note
  /// that only successful queries will be added to the search history.
  Future<void> onSearch(String query) async {
    query = query.toLowerCase().trim();

    if (query.length > 0) {
      // Update the tab before querying
      _activeTab = _searchTab;

      try {
        // Start the progress indicator
        setState(() => _view = CircularProgressIndicator());

        // Wait for the response and update
        final whois = await Whois.query(query);

        setState(
          () {
            _view = WhoisCard(whois);
            _history.add(whois.domain);
          }
        );
      } on FormatException {
        setState(() => _view = ErrorStatus('Invalid domain format'));
      } on SocketException {
        setState(() => _view = ErrorStatus('Invalid domain extension'));
      } on Exception {
        setState(() => _view = ErrorStatus('An unknown error occurred'));
      }
    }
  }

  /// Only navigates when the given tab is different from the active tab.
  void onNavigate(int tab) {
    if (_activeTab != tab) {
      setState(() => _activeTab = tab);
    }
  }

  /// Overwrites the search field and executes the search query again.
  void onRecall(String query) {
    _searchController.text = query;
    onSearch(query);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SearchBar(
            controller: _searchController,
            onSubmitted: onSearch,
          ),
          Expanded(
            child: Align(
              alignment: _alignment,
              child: _view,
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Theme.of(context).bottomAppBarColor,
        currentIndex: _activeTab,
        onTap: onNavigate,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'History',
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
