import 'package:flutter/material.dart';

/// A global search field designed to replace the `AppBar`.
class SearchBar extends StatefulWidget {
  final TextEditingController controller;
  final ValueChanged<String> onSubmitted;

  SearchBar({
    @required this.controller,
    @required this.onSubmitted,
  });

  @override
  _SearchBarState createState() {
    return _SearchBarState();
  }
}

class _SearchBarState extends State<SearchBar> {
  final double _alignment = 14.0;
  final double _elevation = 2.0;
  final double _padding = 10.0;

  /// A tappable clear icon will appear when the search field is non-empty.
  /// Tapping the icon will clear the search field and remove the icon.
  Widget get _suffixIcon {
    if(widget.controller.text.length > 0) {
      return GestureDetector(
        onTap: () => setState(() => widget.controller.clear()),
        child: Icon(Icons.clear),
      );
    }
    return null;
  }

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
            controller: widget.controller,
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                vertical: _alignment,
              ),
              hintText: 'Search',
              prefixIcon: Icon(Icons.search),
              suffixIcon: _suffixIcon,
            ),
            onChanged: (_) => setState(() {}),
            onSubmitted: widget.onSubmitted,
          ),
        ),
      ),
    );
  }
}
