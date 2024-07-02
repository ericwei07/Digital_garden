import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

import 'main.dart';

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
              child: Align(
                alignment: Alignment.topLeft,
                child: TextField(
                  autofocus: true,
                  textAlign: TextAlign.left,
                  textAlignVertical: TextAlignVertical.top,
                  controller: _content,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  decoration: const InputDecoration(
                      border: InputBorder.none,
                      labelText: 'Write your garden here',
                      hintText: 'Write your garden here'
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: FloatingActionButton(
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) {return const MainPage(title: 'Your garden');})),
                child: const Icon(Icons.save),
              ),
            ),
          ],
        ),
      ),
    );
  }
}