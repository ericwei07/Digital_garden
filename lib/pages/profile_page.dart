import 'package:flutter/material.dart';
import 'package:happy_digital_garden/pages/profile_page_controller.dart';

class ProfileContent extends StatefulWidget {
  const ProfileContent({super.key, required this.title});
  final String title;

  @override
  State<ProfileContent> createState() => _ProfileContent();
}

class _ProfileContent extends State<ProfileContent>{
  late ProfilePageController _profilePageController;
  @override
  void initState() {
    super.initState();
    _profilePageController = ProfilePageController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    loadPage();
  }

  Future loadPage() async {
    await _profilePageController.userDetail(context);
    setState(() {});
  }

  @override

  Widget build(BuildContext context) {
    var dateJoined = _profilePageController.result["join_date"];
    var userName = _profilePageController.result["name"];
    var userMail = _profilePageController.result["email"];
    var userID = _profilePageController.result["id"];
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