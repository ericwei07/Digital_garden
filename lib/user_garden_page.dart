import 'package:flutter/material.dart';

import 'main.dart';
import 'new_garden_page.dart';

class MyGardenContent extends StatefulWidget {
  const MyGardenContent({super.key, required this.title});
  final String title;

  @override
  State<MyGardenContent> createState() => _MyGardenContent();
}

class _MyGardenContent extends State<MyGardenContent>{
  var gardenName = "User1's garden";
  var gardenContent = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed pretium urna purus, in ultrices tellus auctor vel. Nam arcu nisl, sodales id porttitor vitae, bibendum non dui. Nullam turpis nisi, fermentum eu volutpat at, bibendum eu orci. Donec vulputate vulputate faucibus. Praesent posuere dolor odio, vel finibus leo ullamcorper pharetra. Aenean porta tincidunt risus quis eleifend. Fusce et elementum erat, quis varius urna. Mauris id pretium dui. Nam congue lorem et sem consectetur, vel varius sapien tempor. Sed auctor ligula id ultrices finibus.Nunc quis nunc mollis, varius nunc ut, feugiat est. Etiam sed vulputate urna, et sagittis augue. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Etiam interdum egestas elementum. Vivamus sit amet ex metus. Interdum et malesuada fames ac ante ipsum primis in faucibus. Nunc et dui vitae dui aliquam feugiat eget vel justo.Fusce sodales sem in venenatis finibus. Sed ut ex eleifend, iaculis magna posuere, mollis lacus. Phasellus condimentum vitae ex non molestie. Maecenas vitae massa viverra, semper purus id, auctor augue. Sed enim turpis, semper ac tortor eget, interdum blandit nulla. Curabitur at leo pharetra, pulvinar massa id, tempus orci. Curabitur maximus facilisis molestie. Quisque diam lorem, aliquam ut neque ac, ullamcorper laoreet purus. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Nunc consequat erat eget elit efficitur eleifend. Donec nulla lacus, luctus in elit quis, suscipit faucibus libero. Vivamus aliquam, tortor in suscipit congue, lacus est dignissim lacus, quis tristique diam risus non urna. Fusce vitae ipsum consequat, varius mauris a, luctus purus. Mauris consectetur lorem vitae purus commodo iaculis. Sed semper id mi sit amet congue. ";

  @override
  Widget build(BuildContext context) {
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

