import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:whoisit/history.dart';
import 'package:whoisit/widgets/home.dart';

/// The main widget and root of the widget tree.
class App extends StatefulWidget {
  final History history;

  App({required this.history});

  @override
  _AppState createState() {
    return _AppState();
  }
}

class _AppState extends State<App> with WidgetsBindingObserver {
  final trimColorLight = const Color(0xFFE6E6E6);
  final trimColorDark = const Color(0xFF1E1E1E);
  final accentColor = const Color(0xFF007DE6);
  final title = 'Whoisit';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Home(
        history: widget.history,
      ),
      theme: ThemeData(
        brightness: Brightness.light,
        accentColor: accentColor,
        bottomAppBarColor: trimColorLight,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        accentColor: accentColor,
        bottomAppBarColor: trimColorDark,
      ),
      title: title,
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addObserver(this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    didChangePlatformBrightness();
  }

  @override
  void didChangePlatformBrightness() {
    final systemBrightness = MediaQueryData.fromWindow(WidgetsBinding.instance!.window).platformBrightness;
    final brightness = systemBrightness == Brightness.light ? Brightness.dark : Brightness.light;
    final color = systemBrightness == Brightness.light ? trimColorLight : trimColorDark;
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: color,
        statusBarIconBrightness: brightness,
        systemNavigationBarColor: color,
        systemNavigationBarIconBrightness: brightness,
      ),
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
  }
}
