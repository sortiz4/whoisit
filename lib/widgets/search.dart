import 'package:flutter/material.dart';
import 'package:whoisit/widgets/app.dart';

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
