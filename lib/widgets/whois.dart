import 'package:flutter/material.dart';
import 'package:whoisit/widgets/scroll.dart';

/// Displays the results of a whois query using a monospaced font. The widget
/// will stretch vertically and scroll horizontally with large responses.
class WhoisCard extends StatelessWidget {
  final double _elevation = 2.0;
  final double _padding = 10.0;
  final String text;

  WhoisCard(this.text);

  @override
  Widget build(BuildContext context) {
    return ScrollbarView(
      child: Card(
        elevation: _elevation,
        margin: EdgeInsets.all(_padding),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(_padding),
              color: Colors.grey[800],
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Response',
                  style: Theme.of(context).textTheme.button.copyWith(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(_padding),
              child: Align(
                alignment: Alignment.centerLeft,
                child: ScrollbarView(
                  scrollDirection: Axis.horizontal,
                  child: Text(
                    text,
                    style: TextStyle(
                      fontFamily: 'RobotoMono',
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
