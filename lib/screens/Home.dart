import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TaskIt'),
        centerTitle: true,
        backgroundColor: Colors.blue[900],
      ),
      body: displayProjectsWidget(),
    );
  }
}

Future<List<dynamic>> fetchProjects() async {
  const BASE_API_URL = String.fromEnvironment('BASE_API_URL', defaultValue: '');
  var result = await http.get(Uri.parse("${BASE_API_URL}projects/4CJkhMgOeOWxo5qnNQfthUyJneV2"));
  return jsonDecode(result.body);
}

displayProjectsWidget() {
  return FutureBuilder(
    future: fetchProjects(),
    builder: (BuildContext context, AsyncSnapshot snapshot) {
      if (snapshot.hasData) {
        return ListView.builder(
          itemCount: snapshot.data.length,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              title: Text(snapshot.data[index]['title']),
              subtitle: Text(snapshot.data[index]['description']),
            );
          },
        );
      } else {
        return Center(child: CircularProgressIndicator());
      }
    }
  );
}