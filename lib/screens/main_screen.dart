import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:prezent/screens/login.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentScreen = 0;

  @override
  void initState() {
    getUser();
    super.initState();
  }

  void getUser() async {
    var phoneNumber =
        FirebaseAuth.instance.currentUser!.phoneNumber.toString().substring(3);
    var res =
        await http.get(Uri.parse("http://172.20.10.5:3000/user/$phoneNumber"));
    if (res.statusCode == 200) {
      print(res.body);
    } else {
      // Show err
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      resizeToAvoidBottomInset: true,
      body: const Center(
        child: Text("Home"),
      ),
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: false,
        showUnselectedLabels: false,
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: "Home",
              tooltip: "Home",
              activeIcon: Icon(Icons.home_filled)),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_search_outlined),
              label: "Search",
              tooltip: "Search",
              activeIcon: Icon(Icons.person_search)),
          BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: "Account",
              tooltip: "Account",
              activeIcon: Icon(Icons.person_rounded)),
          BottomNavigationBarItem(
              icon: Icon(Icons.power_settings_new_sharp),
              label: "LogOut",
              tooltip: "LogOut",
              activeIcon: Icon(Icons.power_settings_new_sharp)),
        ],
        currentIndex: currentScreen,
        onTap: (index) {
          setState(() {
            currentScreen = index;
            if (index == 3) {
              FirebaseAuth.instance.signOut().then((value) {
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                        builder: (BuildContext context) => const LoginScreen()),
                    (route) => false);
              });
            }
          });
        },
      ),
    ));
  }
}
