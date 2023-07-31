import 'package:flutter/material.dart';
import 'package:taskit_mobile/screens/Home.dart';


void main() {
  runApp(App());
}

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TaskIt',
      debugShowCheckedModeBanner: false,
      home: Home(),
    );
  }
}
