import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:shared_preferences/shared_preferences.dart';


import 'main.dart';
import 'new_garden_page.dart';

class MyGardenContent extends StatefulWidget {
  const MyGardenContent({super.key, required this.title});
  final String title;

  @override
  State<MyGardenContent> createState() => _MyGardenContent();
}

class _MyGardenContent extends State<MyGardenContent>{
  final dio = Dio();

  String username = "2";
  Future getGardenList() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final id = 1;
    final response = await dio.get('/article/list?id=$id');
  }

  @override
  Widget build(BuildContext context) {
    var gardenName = "$username's garden";
    var gardenContent = "this is $username's garden";
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
            TextButton(
                onPressed: getGardenList,
                child: Text('aaaaaaaaaaaaaaaa')
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
                child: const Icon(Icons.add),
              ),
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

