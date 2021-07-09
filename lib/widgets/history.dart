import 'package:flutter/material.dart';
import 'package:whoisit/history.dart';

/// Displays the user's search history in reverse chronological order. When a
/// list item is tapped, the contents will be applied to the `onTap` callback.
class HistoryView extends StatelessWidget {
  final History history;
  final ValueSetter<String> onTap;

  HistoryView({required this.history, required this.onTap});

  /// Creates a `ListTile` from a `domain`.
  Widget createTile(String domain) {
    return ListTile(
      leading: Icon(Icons.restore),
      title: Text(domain),
      onTap: () => onTap(domain),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(0.0),
      children: history.map(createTile).toList().reversed.toList(),
    );
  }
}
