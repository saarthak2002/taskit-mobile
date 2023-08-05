import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:taskit_mobile/extentions.dart';

class Profile extends StatefulWidget {
  const Profile({ Key? key }) : super(key: key);
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  late Future userInfo = fecthUserInfo();
  late Future userStats = fecthUserStats();
  late Future<List<dynamic>> collabs = fetchAllCollabsForUser();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
        backgroundColor: Colors.blue[900],
      ),
      body: FutureBuilder(
        future: userInfo,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if(snapshot.hasData) {
            return Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          '${snapshot.data['firstname']} ${snapshot.data['lastname']}',
                          style: const TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () => FirebaseAuth.instance.signOut(), 
                        child: const Text('Logout'),
                      ),
                    ],
                  ),
                ),
                CircleAvatar(
                  radius: 80,
                  backgroundColor: Colors.blue[900],
                  child: Text(
                    '${snapshot.data['firstname'].toString().capitalize().characters.first}${snapshot.data['lastname'].toString().capitalize().characters.first}',
                    style: const TextStyle(
                      fontSize: 50,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
                  child: Center(
                    child: Text(
                      '@${snapshot.data['username']}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w300,
                        color: Color.fromARGB(255, 77, 76, 76),
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 20, right: 20, top: 3),
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Center(
                    child: Text(
                      '${FirebaseAuth.instance.currentUser!.email}',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w300,
                        color: Color.fromARGB(255, 77, 76, 76),
                      ),
                    ),
                  ),
                ),
                FutureBuilder(
                  future: userStats,
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if(snapshot.hasData) {
                      return Row(
                        children: [
                          Expanded(
                            child: Container(
                              margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
                              padding: const EdgeInsets.only(bottom: 10),
                              child: Column(
                                children: [
                                  Text(
                                    '${snapshot.data['total_projects']}',
                                    style: const TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                    ),
                                  ),
                                  const Text(
                                    'Projects',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w300,
                                      color: Color.fromARGB(255, 77, 76, 76),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
                              padding: const EdgeInsets.only(bottom: 10),
                              child: Column(
                                children: [
                                  Text(
                                    '${snapshot.data['total_tasks']}',
                                    style: const TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                    ),
                                  ),
                                  const Text(
                                    'Tasks',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w300,
                                      color: Color.fromARGB(255, 77, 76, 76),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
                              padding: const EdgeInsets.only(bottom: 10),
                              child: Column(
                                children: [
                                  Text(
                                    '${snapshot.data['completed_tasks']}',
                                    style: const TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                    ),
                                  ),
                                  const Text(
                                    'Completed',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w300,
                                      color: Color.fromARGB(255, 77, 76, 76),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    }
                    else{
                      return const Center(child: CircularProgressIndicator());
                    }
                  }
                ),
                Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(left: 20, top: 15),
                      child: const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Collaborations',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    FutureBuilder(
                      future: collabs,
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if(snapshot.hasData) {
                          return Container(
                            margin: const EdgeInsets.only(left: 20, right: 20, top:10),
                            height: 50,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: snapshot.data.length,
                              itemBuilder: (BuildContext context, int index) {
                                var collab = snapshot.data[index];
                                return Container(
                                  padding: const EdgeInsets.all(5),
                                  child: Tooltip(
                                    message: '${collab['firstname']} ${collab['lastname']}',
                                    child: CircleAvatar(
                                      backgroundColor: Colors.blue[900],
                                      child: Text('${collab['firstname'].toString().characters.first}${collab['lastname'].toString().characters.first}'),
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        }
                        else {
                          return Container(
                            margin: const EdgeInsets.all(20),
                            child: const Center(child: CircularProgressIndicator()),
                          );
                        }
                      }
                    ),
                  ],
                ),
              ],
            );
          }
          else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      )
    );
  }

  Future fecthUserInfo() async {
    var user = FirebaseAuth.instance.currentUser;
    const BASE_API_URL = String.fromEnvironment('BASE_API_URL', defaultValue: '');
    var result = await http.get(Uri.parse("${BASE_API_URL}users/${user!.uid}"));
    var decodedResponse = jsonDecode(result.body);
    return decodedResponse;
  }

  Future fecthUserStats() async {
    var user = FirebaseAuth.instance.currentUser;
    const BASE_API_URL = String.fromEnvironment('BASE_API_URL', defaultValue: '');
    var result = await http.get(Uri.parse("${BASE_API_URL}stats/basic/${user!.uid}"));
    var decodedResponse = jsonDecode(result.body);
    return decodedResponse;
  }

  Future<List<dynamic>> fetchAllCollabsForUser() async {
    var user = FirebaseAuth.instance.currentUser;
    const BASE_API_URL = String.fromEnvironment('BASE_API_URL', defaultValue: '');
    var result = await http.get(Uri.parse("${BASE_API_URL}collabs/getcollabsbyuid/${user!.uid}"));
    return jsonDecode(result.body);
  }
}