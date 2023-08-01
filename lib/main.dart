import 'package:flutter/material.dart';
import 'package:taskit_mobile/screens/Home.dart';
import 'package:taskit_mobile/screens/Collab.dart';
import 'package:taskit_mobile/screens/Profile.dart';
import 'package:taskit_mobile/screens/Login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';


Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

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
    return const MaterialApp(
      title: 'TaskIt',
      debugShowCheckedModeBanner: false,
      home: MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);
  
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int selectedPage = 0;
  @override
  Widget build(BuildContext context) => Scaffold(
    body: StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if(snapshot.hasData) {
          final _pageOptions = [
            Home(),
            Collab(),
            Profile(),
          ];
          return Scaffold(
            body: _pageOptions[selectedPage],
            bottomNavigationBar: BottomNavigationBar(
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.home, size: 30), label: 'Projects'),
                BottomNavigationBarItem(icon: Icon(Icons.groups, size: 30), label: 'Collaborate'),
                BottomNavigationBarItem(icon: Icon(Icons.account_circle, size: 30), label: 'Profile'),
              ],
              selectedItemColor: Colors.deepPurple[200],
              elevation: 5.0,
              unselectedItemColor: Colors.white60,
              currentIndex: selectedPage,
              backgroundColor: Colors.blue[900],
              onTap: (index) {
                setState(() {
                  selectedPage = index;
                });
              },
            )
          );
        }
        else {
          return Login();
        }
      },
    ),
  );
}