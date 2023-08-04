import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:taskit_mobile/screens/ProjectDetails.dart';

class Collab extends StatefulWidget {
  const Collab({ Key? key }) : super(key: key);
  @override
  _CollabState createState() => _CollabState();
}

class _CollabState extends State<Collab> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Collaborations'),
        centerTitle: true,
        backgroundColor: Colors.blue[900],
      ),
      body: Column (
        children: [
          Container(
            margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
            padding: const EdgeInsets.only(bottom: 10),
            child: const Align(
              alignment: Alignment.topLeft,
              child: Text(
                'Your Collaborations',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          Expanded(
            child: displayProjectsWidget(),
          ),
        ],
      ),
    );
  }
}

Future<List<dynamic>> fetchProjects() async {
  var user = FirebaseAuth.instance.currentUser;
  const BASE_API_URL = String.fromEnvironment('BASE_API_URL', defaultValue: '');
  var result = await http.get(Uri.parse("${BASE_API_URL}collabs/projects/${user!.uid}"));
  return jsonDecode(result.body);
}

displayProjectsWidget() {
  return FutureBuilder(
    future: fetchProjects(),
    builder: (BuildContext context, AsyncSnapshot snapshot) {
      if (snapshot.hasData) {
        if (snapshot.data.length == 0) {
          return Center(child: Text('No projects found'));
        }
        return ListView.builder(
          itemCount: snapshot.data.length,
          itemBuilder: (BuildContext context, int index) {
            return card(context, snapshot.data[index]);
          },
        );
      } else {
        return Center(child: CircularProgressIndicator());
      }
    }
  );
}

card(context, project) {
  return Card(
    margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
    elevation: 2,
    color: Colors.lightBlue[100],
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    child: InkWell (
      highlightColor: Colors.deepPurple[50],
      splashColor: Colors.deepPurple[200],
      customBorder: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProjectDetails(project),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column (
          children: [
            Row (
              children: [
                Expanded(
                  child: Text(
                    project['title'],
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.all(6),
                  child: Text(
                    project['tasks'].length.toString() + ' tasks',
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.only(top: 8),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  project['description'],
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            Container(
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  project['date_added'].toString().substring(0, 17),
                  style: const TextStyle(
                    fontSize: 11,
                    color: Colors.black54,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}