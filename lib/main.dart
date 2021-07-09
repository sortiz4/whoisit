import 'package:flutter/material.dart';
import 'package:whoisit/history.dart';
import 'package:whoisit/widgets/app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(App(history: await History.fromStorage()));
}
