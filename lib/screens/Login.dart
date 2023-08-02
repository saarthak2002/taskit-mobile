import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
    
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool loading = false;

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Login'),
          centerTitle: true,
          backgroundColor: Colors.blue[900],
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
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
            Container(
              margin: const EdgeInsets.only(bottom: 10),
              child: TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  hintText: 'Email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  filled: true,
                  fillColor: Colors.white70,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 10),
              child: TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  hintText: 'Password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  filled: true,
                  fillColor: Colors.white70,
                ),
              ),
            ),
            SignInButton(
              Buttons.Email,
              text: "Login with Email",
              onPressed: () {signIn();},
            ),
            SignInButton(
              Buttons.GoogleDark,
              text: "Continue with Google",
              onPressed: () {signInWithGoogle();},
            ),
          ],
        ),
      )
    );
  }

  Future signIn() async {
    setState(() {
      loading = true;
    });
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      setState(() {
        loading = false;
      });
    }
    catch(error) {
      const snackBar = SnackBar(content: Text('Sign-in failed. Please check your credentials.'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      setState(() {
        loading = false;
      });
    }
  }

  Future<UserCredential> signInWithGoogle() async {
    setState(() {
      loading = true;
    });
    try{
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      var userCredentials =  await FirebaseAuth.instance.signInWithCredential(credential);
      return userCredentials;
    }
    catch (error) {
      const snackBar = SnackBar(content: Text('Sign-in failed. Please check your credentials.'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      setState(() {
        loading = false;
      });
      rethrow;
    }
  }
}

