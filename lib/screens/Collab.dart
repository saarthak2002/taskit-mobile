import 'package:flutter/material.dart';

class Collab extends StatefulWidget {
  const Collab({ Key? key }) : super(key: key);
  @override
  _CollabState createState() => _CollabState();
}

class _CollabState extends State<Collab> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text('Collab'),
      ),
    );
  }
}