import 'package:flutter/material.dart';

/// A global search field replacing the usual `AppBar`.
class SearchBar extends StatelessWidget {
  final double _elevation = 2.0;
  final double _padding = 10.0;
  final TextEditingController controller;
  final ValueChanged<String> onSubmitted;

  SearchBar({
    @required this.controller,
    @required this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).primaryColor,
      elevation: _elevation,
      child: Container(
        padding: EdgeInsets.only(
          top: _padding + MediaQuery.of(context).padding.top,
          bottom: _padding,
          left: _padding,
          right: _padding,
        ),
        child: Card(
          elevation: _elevation,
          child: TextField(
            autocorrect: false,
            controller: controller,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: 'Search',
              prefixIcon: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: _padding,
                ),
                child: Icon(Icons.search),
              ),
            ),
            onSubmitted: onSubmitted,
          ),
        ),
      ),
    );
  }
}
