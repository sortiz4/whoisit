import 'package:flutter/material.dart';

/// A simple background status indicator with an icon and short description.
class Status extends StatelessWidget {
  final double _padding = 8.0;
  final double _opacity = 0.5;
  final IconData icon;
  final String text;

  Status({
    @required this.icon,
    @required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: _opacity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(_padding),
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

/// Indicates the user's search history is empty.
class EmptyHistoryStatus extends Status {
  EmptyHistoryStatus() : super(
    icon: Icons.info,
    text: 'Your search history is empty',
  );
}

/// Indicates the user hasn't searched for anything.
class EmptySearchStatus extends Status {
  EmptySearchStatus() : super(
    icon: Icons.search,
    text: 'Search for something...',
  );
}

/// Indicates an error has occurred.
class ErrorStatus extends Status {
  ErrorStatus(String text) : super(
    icon: Icons.error,
    text: text,
  );
}
