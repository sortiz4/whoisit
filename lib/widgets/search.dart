import 'package:flutter/material.dart';

/// A global search field designed to replace the `AppBar`.
class SearchBar extends StatefulWidget {
  final TextEditingController controller;
  final ValueChanged<String> onSubmitted;

  SearchBar({required this.controller, required this.onSubmitted});

  @override
  _SearchBarState createState() {
    return _SearchBarState();
  }
}

class _SearchBarState extends State<SearchBar> {
  final double _alignment = 15.0;
  final double _elevation = 2.0;
  final double _padding = 10.0;

  /// A tappable clear icon will appear when the search field is non-empty.
  /// Tapping the icon will clear the search field and remove the icon.
  Widget? get _suffixIcon {
    return widget.controller.text.length > 0 ? (
      GestureDetector(onTap: onClear, child: Icon(Icons.clear))
    ) : (
      null
    );
  }

  /// Rebuilds the search tree when a change is made.
  void onChange() {
    setState(() {});
  }

  /// Clears the search controller.
  void onClear() {
    WidgetsBinding.instance?.addPostFrameCallback((_) => widget.controller.clear());
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).bottomAppBarColor,
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
            onSubmitted: widget.onSubmitted,
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(onChange);
  }

  @override
  void dispose() {
    widget.controller.removeListener(onChange);
    super.dispose();
  }
}
