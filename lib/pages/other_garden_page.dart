import 'package:flutter/material.dart';

import 'main.dart';

class AllGardenContent extends StatefulWidget {
  const AllGardenContent({super.key, required this.title});
  final String title;

  @override
  State<AllGardenContent> createState() => _AllGardenContent();
}

class _AllGardenContent extends State<AllGardenContent>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView (
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Row(
              children: <Widget>[
                Text('Newest garden are here'),
              ],
            ),
            TextButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context, MaterialPageRoute(builder: (context) => const Dummypage(title: 'home page',)),
                        (Route<dynamic> route) => false,
                  );
                },
                child: const Text('garden1')
            ),
          ],
        ),
      ),
    );
  }
}
