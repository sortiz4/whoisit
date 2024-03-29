import 'package:flutter/material.dart';
import 'package:whoisit/whois.dart';

/// Displays the results of a WHOIS query using a monospaced font. The widget
/// will stretch vertically and scroll horizontally with large responses, but
/// will wrap exceptionally long unbroken lines.
class WhoisCard extends StatelessWidget {
  final double _elevation = 2.0;
  final double _padding = 10.0;
  final Whois whois;

  WhoisCard(this.whois);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Card(
        clipBehavior: Clip.hardEdge,
        elevation: _elevation,
        margin: EdgeInsets.all(_padding),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(_padding),
              color: Theme.of(context).bottomAppBarColor,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(whois.server),
              ),
            ),
            Container(
              padding: EdgeInsets.all(_padding),
              child: Align(
                alignment: Alignment.centerLeft,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Container(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 3,
                    ),
                    child: Text(
                      whois.response,
                      style: TextStyle(
                        fontFamily: 'RobotoMono',
                      ),
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
