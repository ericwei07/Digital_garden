import 'package:flutter/material.dart';

class ProfileContent extends StatefulWidget {
  const ProfileContent({super.key, required this.title});
  final String title;

  @override
  State<ProfileContent> createState() => _ProfileContent();
}

class _ProfileContent extends State<ProfileContent>{
  var dateJoined = "01/02/2034";
  var userName = "user1";
  var userMail = 'user1@gmail.com';
  var userID = '00000001';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.circular(40.0),
                child: Image.asset("../assets/images/placeholder.jpg"),
              ),
              const SizedBox(width: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Username: $userName'),
                  Text('UID: $userID'),
                ],
              ),
            ],
          ),
          const SizedBox(height: 30),
          Text("Join date: $dateJoined"),
          Text('Email address: $userMail'),
        ],
      ),
    );
  }
}