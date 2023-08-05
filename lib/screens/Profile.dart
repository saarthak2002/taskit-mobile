import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Profile extends StatefulWidget {
  const Profile({ Key? key }) : super(key: key);
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  late Future userInfo = fecthUserInfo();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
        backgroundColor: Colors.blue[900],
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
            padding: const EdgeInsets.only(bottom: 10),
            child: FutureBuilder(
              future: userInfo,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if(snapshot.hasData) {
                  return Row(
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
                  );
                }
                else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            )
          ),
        ],
      ),
    );
  }

  Future fecthUserInfo() async {
    var user = FirebaseAuth.instance.currentUser;
    const BASE_API_URL = String.fromEnvironment('BASE_API_URL', defaultValue: '');
    var result = await http.get(Uri.parse("${BASE_API_URL}users/${user!.uid}"));
    var decodedResponse = jsonDecode(result.body);
    return decodedResponse;
  }
}