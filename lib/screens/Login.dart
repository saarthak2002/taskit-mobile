import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
    
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Login'),
          centerTitle: true,
          backgroundColor: Colors.blue[900],
        ),
        body: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  hintText: 'Email',
                ),
              ),
              TextField(
                controller: passwordController,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  hintText: 'Password',
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  print(emailController.text);
                  print(passwordController.text);
                  signIn();
                },
                child: const Text('Login'),
              ),
              ElevatedButton(
                onPressed: () {signInWithGoogle();},
                child: const Text('Continue with Google'),
              ),
            ],
          ),
        ));
  }

  Future signIn() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
    }
    catch(error) {
      final snackBar = SnackBar(content: Text('Sign-in failed. Please check your credentials.'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  Future<UserCredential> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    var userCredentials =  await FirebaseAuth.instance.signInWithCredential(credential);
    print(userCredentials.user?.uid);
    return userCredentials;
  }
}

