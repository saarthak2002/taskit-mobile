import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Profile extends StatefulWidget {
  const Profile({ Key? key }) : super(key: key);
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
        backgroundColor: Colors.blue[900],
      ),
      body: Container(
        child: Center(
          child: Row(
            children: [
              Text('Profile'),
              const Spacer(),
              ElevatedButton(
                onPressed: () => FirebaseAuth.instance.signOut(), 
                child: const Text('Logout'),
              ),
            ]
          ),
        ),
      ),
    );
  }
}