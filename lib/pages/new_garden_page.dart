import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../app_config.dart';
import '../main.dart';

class NewGardenPage extends StatefulWidget {
  const NewGardenPage({super.key, required this.title});

  final String title;

  @override
  State<NewGardenPage> createState() => _NewGardenPage();
}

class _NewGardenPage extends State<NewGardenPage> {
  final _content = TextEditingController();
  final _title = TextEditingController();
  Dio dio = Dio();

  Future<void> createArticle() async {
    dio.options.baseUrl = AppConfig.baseUrl;
    Response response;
    final prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('accessToken');
    if (token == null || token == '') {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const MyHomePage(
            title: 'home page',
          )
        ),
        (Route<dynamic> route) => false,
      );
      return;
    }
    final jwt = JWT.decode(token);
    final exp = jwt.payload['exp'];
    final expiryDate = DateTime.fromMillisecondsSinceEpoch(exp * 1000);
    final currentTime = DateTime.now();
    if (expiryDate.difference(currentTime).inSeconds < 0) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const MyHomePage(
            title: 'home page',
          )
        ),
        (Route<dynamic> route) => false,
      );
    }
    response = await dio.post('/article/post', data: {'title': _title.text, 'content': _content.text, 'writer': jwt.payload["id"]});
    if (response.data['result'] == 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('title/content can not be empty'),
        ),
      );
    } else {
      Navigator.pop(context);
    }
  }

  Future<void> checkInput() async {
    if (_content.text.isEmpty || _title.text.isEmpty) {
      var emptyField = '';
      if (_content.text.isEmpty) {
        emptyField += 'Content';
      }
      if (_title.text.isEmpty) {
        if (emptyField != '') {
          emptyField += ' and ';
        }
        emptyField += 'Title';
      }
      if (emptyField.isNotEmpty) {
        emptyField += ' can not be empty';
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(emptyField),
        ),
      );
    } else {
      await createArticle();
    }
  }

  checkIfEmpty(bool didpop) async {
    if (_content.text.isEmpty && _title.text.isEmpty) {
      Navigator.pop(context);
    } else {
      var result = await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Are you sure you want to quit without saving'),
            actions: <Widget>[
              TextButton(
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
              ),
              TextButton(
                child: const Text('Quit'),
                onPressed: () async {
                  Navigator.of(context).pop(true);
                },
              ),
            ],
          );
        },
      );
      if (result!) {
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: checkIfEmpty,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
        ),
        body: Stack(
          children: [
            Container(
              margin: EdgeInsets.only(left: 30, right: 30, top: 10),
              child: Column(
                children: [
                  SizedBox(
                    height: 50,
                    width: MediaQuery.sizeOf(context).width,
                    child: TextField(
                      autofocus: true,
                      textAlign: TextAlign.left,
                      textAlignVertical: TextAlignVertical.top,
                      controller: _title,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      decoration: const InputDecoration(border: InputBorder.none, labelText: 'Title', hintText: 'Write the article title here'),
                    ),
                  ),
                  Expanded(
                    child:  TextField(
                      autofocus: true,
                      textAlign: TextAlign.left,
                      textAlignVertical: TextAlignVertical.top,
                      controller: _content,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      decoration: const InputDecoration(border: InputBorder.none, labelText: 'Write your article here', hintText: 'Write your article here'),
                    )
                  )
                ]
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Container(
                margin: const EdgeInsets.all(20),
                child: FloatingActionButton(
                  onPressed: () => checkInput(),
                  child: const Icon(Icons.save),
                ),
              )
            )
          ],
        )
      ),
    );
  }
}
