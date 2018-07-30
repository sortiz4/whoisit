import 'package:flutter/material.dart';

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

class ErrorStatus extends Status {
  ErrorStatus(String text) : super(
    icon: Icons.error,
    text: text,
  );
}
