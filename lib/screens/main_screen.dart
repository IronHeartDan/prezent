import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:prezent/screens/login.dart';
import 'package:prezent/screens/profile_screen.dart';
import 'package:prezent/screens/search_screen.dart';

import 'home_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with TickerProviderStateMixin {
  int currentScreen = 0;
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      setState(() {
        currentScreen = _tabController.index;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: TabBarView(
            controller: _tabController,
            children: const [HomeScreen(), SearchScreen(), ProfileScreen()]),
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
        onTap: (index) async {
          if (index == 3) {
            await showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    content: const Text("LogOut?"),
                    actions: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text("Cancel"),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          LogOut();
                        },
                        child: const Text("Yes"),
                      ),
                    ],
                  );
                });
          } else {
            setState(() {
              currentScreen = index;
              _tabController.index = index;
            });
          }
        },
      ),
    );
  }

  void LogOut() {
    FirebaseAuth.instance.signOut().then((value) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
              builder: (BuildContext context) => const LoginScreen()),
          (route) => false);
    });
  }
}
