import 'package:flutter/material.dart';
import 'package:whoisit/history.dart';

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
