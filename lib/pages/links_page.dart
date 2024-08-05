import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../app_config.dart';
import '../main.dart';
import 'linked_user_page.dart';
import 'links_page_controller.dart';

class MyLinks extends StatefulWidget {
  const MyLinks({super.key, required this.title});

  final String title;

  @override
  State<MyLinks> createState() => _MyLinks();
}

class _MyLinks extends State<MyLinks> {
  final _addLinkUsername = TextEditingController();
  late LinksPageController _LinksPageController;
  Dio dio = Dio();

  @override
  void initState() {
    super.initState();
    _LinksPageController = LinksPageController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    loadPage();
  }

  Future loadPage() async {
    await _LinksPageController.getLinkList(context);
    setState(() {});
  }

  Future<void> deleteLink(id) async {
    dio.options.baseUrl = AppConfig.baseUrl;
    Response response;
    response = await dio.delete('/links/delete?id=${id}');
    if (response.data['result'] == 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('id can not be empty'),
        ),
      );
    }
  }

  Future<void> showDialogue() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Write the username in the text field below'),
          content: SizedBox(
            width: 200,
            child: TextField(
              controller: _addLinkUsername,
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Add'),
              onPressed: () {
                addLink();
              },
            ),
          ],
        );
      },
    );
  }

  void addLink() async {
    if (_addLinkUsername.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Username can not be empty"),
        ),
      );
    } else {
      await request(_addLinkUsername.text);
    }
  }

  Future<void> request(name) async {
    dio.options.baseUrl = AppConfig.baseUrl;
    final navigator = Navigator.of(context);
    final prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('accessToken');
    if (token == null || token == '') {
      navigator.pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => const MyHomePage(
            title: 'home page',
          ),
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
      navigator.pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => const MyHomePage(
            title: 'home page',
          ),
        ),
            (Route<dynamic> route) => false,
      );
    }
    final id = jwt.payload["id"];
    Response response;
    response = await dio.post('/links/add', data: {'username': name, 'id': id});
    if (response.data['result'] == 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('username/id is empty'),
        ),
      );
    } else if (response.data['result'] == 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('link already exist'),
        ),
      );
    } else if (response.data['result'] == 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('user does not exist'),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('link successfully added'),
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final usernames = _LinksPageController.result['usernames'];
    final links = _LinksPageController.result['links'];
    final linkId = _LinksPageController.result['link_id'];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: _LinksPageController.isLoading ? const Align(
        alignment: Alignment.center,
        child: CircularProgressIndicator(),
      ) : Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              (linkId?.length == 0) ? const Text("Your list is empty, try create a new one") : Expanded(child:
              ListView.builder(
                itemCount: links.length,
                itemBuilder: (context, index) {
                  String username = usernames[index];
                  int id = linkId[index];
                  int user_id = links[index];
                  return ListTile(
                    title: Text(username),
                    onTap: () {
                      Navigator.push(
                        context, MaterialPageRoute(
                          builder: (context) => LinkedUserPage(id: user_id, username: username)
                      ),
                      );
                    },
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => deleteLink(id),
                    ),
                  );
                },
              )
              )
            ],
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () => showDialogue(),
            ),
          )
        ],
      )
    );
  }
}
