import 'package:flutter/material.dart';
import 'package:whoisit/history.dart';

/// Displays the user's search history in reverse chronological order. When a
/// list item is tapped, the contents will be applied to the `onTap` callback.
class HistoryView extends StatelessWidget {
  final History history;
  final ValueSetter<String> onTap;

  HistoryView({this.history, this.onTap});

  @override
  Widget build(BuildContext context) {
    // Map the history to list items
    var widgets = <Widget>[];
    for(var domain in history) {
      widgets.add(ListTile(
        leading: Icon(Icons.restore),
        title: Text(domain),
        onTap: () => onTap(domain),
      ));
    }

    // Display the list in reverse (most recent)
    return Scrollbar(
      child: ListView(
        padding: EdgeInsets.all(0.0),
        children: widgets.reversed.toList(),
      ),
    );
  }
}
