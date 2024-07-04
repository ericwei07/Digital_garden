import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';


class Settings extends StatefulWidget {
  const Settings({super.key, required this.title});
  final String title;

  @override
  State<Settings> createState() => _Settings();
}

class _Settings extends State<Settings>{
  Future<void> signOut() async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.remove("accessToken");
    Navigator.pushAndRemoveUntil(
      context, MaterialPageRoute(
        builder: (context) => const MyHomePage(title: 'home page',)
      ),
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Align(
            alignment: Alignment.center,
            child: ElevatedButton(
              onPressed: () {
                signOut();
              },
              child: const Text('Log out'),
            ),
          ),
        ],
      ),
    );
  }
}

