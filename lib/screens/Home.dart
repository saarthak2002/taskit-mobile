import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:taskit_mobile/screens/ProjectDetails.dart';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  var user = FirebaseAuth.instance.currentUser;
  late Future userInfo = fecthUserInfo();

  TextEditingController projectTitleController = TextEditingController();
  TextEditingController projectDescriptionController = TextEditingController();
  bool projectTitleError = false;
  bool projectDescriptionError = false;
  bool isUpdatingProjects = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Projects'),
        centerTitle: true,
        backgroundColor: Colors.blue[900],
      ),
      body: Column (
        children: [
          Container(
            margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
            padding: const EdgeInsets.only(bottom: 10),
            child: Align(
              alignment: Alignment.topLeft,
              child: FutureBuilder(
                future: userInfo,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    return Text(
                      'Welcome, ${snapshot.data['firstname']} ${snapshot.data['lastname']}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    );
                  }
                  else {
                    return const Text(
                      'Welcome back',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    );
                  }
                },
              ),
            ),
          ),
          Expanded(
            child: displayProjectsWidget(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            useSafeArea: true,
            builder: (BuildContext context) {
              return (
                StatefulBuilder(
                  builder: (BuildContext context, StateSetter setDropdownState) {
                    return addProjectModal(context, setDropdownState);
                  },
                )
              );
            }
          );
        },
        backgroundColor: Colors.blue[900],
        child: const Icon(Icons.add),
      ),
    );
  }

  addProjectModal(context, setDropdownState) {
    return (
      Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom
        ),
        child: Container (
          height: 500,
          child: Padding (
            padding: const EdgeInsets.all(20),
            child: Column (
              children: [
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Create Project',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close),
                      tooltip: 'Close',
                    ),
                  ],
                ),
                Container(
                  margin: const EdgeInsets.only(top: 20),
                  child: TextField(
                    controller: projectTitleController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      filled: true,
                      labelText: 'Title',
                      hintText: 'Title',
                      fillColor: Colors.white70,
                      errorText: projectTitleError ? 'Please enter a title' : null,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 10),
                  child: TextField(
                    controller: projectDescriptionController,
                    maxLines: 5,
                    minLines: 3,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      filled: true,
                      labelText: 'Description',
                      hintText: 'Description',
                      fillColor: Colors.white70,
                      errorText: projectDescriptionError ? 'Please enter a description' : null,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 10),
                  child: ElevatedButton(
                    onPressed: () {
                      addProject(context, setDropdownState);
                    },
                    child: const Text('Add Project'),
                  ),
                ),
              ],
            ),
          ),
        ),
      )
    );
  }

  addProject(context, setDropdownState) async {
    String title = projectTitleController.text.trim();
    String description = projectDescriptionController.text.trim();
    if(title == '') {
      setDropdownState(() {
        projectTitleError = true;
      });
      return;
    }
    else {
      setDropdownState(() {
        projectTitleError = false;
      });
    }
    if(description == '') {
      setDropdownState(() {
        projectDescriptionError = true;
      });
      return;
    }
    else {
      setDropdownState(() {
        projectDescriptionError = false;
      });
    }
    Navigator.pop(context);
    setState(() {
      isUpdatingProjects = true;
    });
    var user = FirebaseAuth.instance.currentUser;
    const BASE_API_URL = String.fromEnvironment('BASE_API_URL', defaultValue: '');
    
    final reponse = await http.post(
      Uri.parse(BASE_API_URL + 'projects'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        "title":title,
        "description": description,
        "userUID": user!.uid,
      }),
    );
    print(reponse.body);

    projectDescriptionController.clear();
    projectTitleController.clear();
    setState(() {
      fetchProjects();
      isUpdatingProjects = false;
    });
  }

  Future<List<dynamic>> fetchProjects() async {
    var user = FirebaseAuth.instance.currentUser;
    const BASE_API_URL = String.fromEnvironment('BASE_API_URL', defaultValue: '');
    var result = await http.get(Uri.parse("${BASE_API_URL}projects/${user!.uid}"));
    return jsonDecode(result.body);
  }

  Future fecthUserInfo() async {
    var user = FirebaseAuth.instance.currentUser;
    const BASE_API_URL = String.fromEnvironment('BASE_API_URL', defaultValue: '');
    var result = await http.get(Uri.parse("${BASE_API_URL}users/${user!.uid}"));
    var decodedResponse = jsonDecode(result.body);

    if(decodedResponse['error'] == 'User not found') {
      print('User does not exist');
      var firstName = user.displayName!.split(' ')[0];
      var lastName = user.displayName!.split(' ')[1];
      var userUid = user.uid;
      var username = user.email!.split('@')[0] + user.uid.substring(0, 7);
    
      final response = await http.post(
        Uri.parse("${BASE_API_URL}users"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'firstName': firstName,
          'lastName': lastName,
          'userUID': userUid,
          'username': username,
        }),
      );
      print(response.body);
    }
    return jsonDecode(result.body);
  }

  displayProjectsWidget() {
    return FutureBuilder(
      future: fetchProjects(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting || isUpdatingProjects) {
          return const Center(child: CircularProgressIndicator());
        }
        else if (snapshot.hasData) {
          if (snapshot.data.length == 0) {
            return const Center(child: Text('No projects found'));
          }
          return ListView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (BuildContext context, int index) {
              return card(context, snapshot.data[index]);
            },
            padding: const EdgeInsets.only(bottom: 30),
          );
        }
        else {
          return const Center(child: CircularProgressIndicator());
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
}