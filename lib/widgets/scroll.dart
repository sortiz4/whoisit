import 'package:flutter/material.dart';

/// Combines a scrollbar and a scrollable view into a single component.
class ScrollbarView extends StatelessWidget {
  final Axis scrollDirection;
  final Widget child;

  ScrollbarView({this.scrollDirection, this.child});

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      child: SingleChildScrollView(
        scrollDirection: scrollDirection ?? Axis.vertical,
        child: child,
      ),
    );
  }
}
