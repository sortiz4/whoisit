import 'package:flutter/material.dart';
import 'package:whoisit/widgets/home.dart';

class App extends StatelessWidget {
  static final backgroundColor = const Color(0xFFEEEEEE);
  static final primaryColor = const Color(0xFF007DE6);
  static final shadowColor = const Color(0x33000000);
  static final title = 'whoisit';

  static final theme = ThemeData(
    backgroundColor: backgroundColor,
    primaryColor: primaryColor,
    accentColor: primaryColor,
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Home(),
      theme: theme,
      title: title,
    );
  }
}
