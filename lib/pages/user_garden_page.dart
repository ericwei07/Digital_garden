import 'dart:async';

import 'package:flutter/material.dart';

import 'main.dart';
import 'new_garden_page.dart';
import 'user_garden_page_controller.dart';

class MyGardenContent extends StatefulWidget {
  const MyGardenContent({super.key, required this.title});
  final String title;

  @override
  State<MyGardenContent> createState() => _MyGardenContent();
}

class _MyGardenContent extends State<MyGardenContent> {
  late UserGardenPageController _userGardenPageController;
  @override
  void initState() {
    super.initState();
    _userGardenPageController = UserGardenPageController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    loadPage();
  }

  Future loadPage() async {
    await _userGardenPageController.getGardenList(context);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final username = _userGardenPageController.result['username'];
    final articles = _userGardenPageController.result['content'];
    final gardenName = "$username's garden";
    final gardenContent = "this is $username's garden";
    return Scaffold(
      body: SingleChildScrollView (
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              gardenName,
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0
              ),
            ),
            Text(gardenContent),
            TextButton(
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) {return const Dummypage(title: 'article');})),
                child: Text('garden1')
            ),
            TextButton(
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) {return const Dummypage(title: 'article');})),
                child: Text('garden2')
            ),
            TextButton(
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) {return const Dummypage(title: 'article');})),
                child: Text('garden3')
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: FloatingActionButton(
                heroTag: null,
                onPressed: () {
                  Navigator.push(
                    context, MaterialPageRoute(builder: (context) => const NewGardenPage(title: 'digital garden',)),
                  );
                },
                child: const Icon(Icons.edit),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

