import 'package:flutter/material.dart';

import 'main.dart';


class Settings extends StatefulWidget {
  const Settings({super.key, required this.title});
  final String title;




  @override
  State<Settings> createState() => _Settings();
}




class _Settings extends State<Settings>{
  final ValueNotifier<ThemeMode> _notifier = ValueNotifier(ThemeMode.light);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context, MaterialPageRoute(
                  builder: (context) => const MyHomePage(title: 'home page',)),
                    (Route<dynamic> route) => false,
              );
            },
            child: const Text('Log out'),
          ),
        ],
      ),
    );
  }
}

