import 'package:flutter/material.dart';
import 'package:happy_digital_garden/main.dart';

class NewGardenPage extends StatefulWidget {
  const NewGardenPage({super.key, required this.title});
  final String title;

  @override
  State<NewGardenPage> createState() => _NewGardenPage();
}

class _NewGardenPage extends State<NewGardenPage> {
  final _content = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: TextField(
                controller: _content,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  labelText: 'Write your garden here',
                  hintText: 'Write your garden here'
                ),
              ),
            ),
            FloatingActionButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) {return const MainPage(title: 'Your garden');})),
              child: const Icon(Icons.save),
            )
          ],
        ),
      ),
    );
  }
}