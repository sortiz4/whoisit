import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:whoisit/history.dart';
import 'package:whoisit/widgets/app.dart';

Future<void> main() async {
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );
  WidgetsFlutterBinding.ensureInitialized();
  runApp(App(history: await History.fromStorage()));
}
