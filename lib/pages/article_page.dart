import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:happy_digital_garden/pages/article_page_controller.dart';
import 'package:happy_digital_garden/pages/edit_article_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../app_config.dart';
import '../main.dart';


class ArticlePage extends StatefulWidget {
  const ArticlePage({super.key, required this.title, required this.id});
  final String title;
  final int id;
  @override
  State<ArticlePage> createState() => _ArticlePage();
}

class _ArticlePage extends State<ArticlePage> {
  late ArticlePageController _articlePageController;
  final _commentsTextController = TextEditingController();

  Dio dio = Dio();
  Future<void> deleteArticle() async {
    dio.options.baseUrl = AppConfig.baseUrl;
    Response response;
    response = await dio.delete('/article/delete?id=${widget.id}');
    if (response.data['result'] == 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('id can not be empty'),
        ),
      );
    } else {
      Navigator.pop(context);
    }
  }

  void checkComment() async {
    if (_commentsTextController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("comment can not be empty"),
        ),
      );
    } else {
      await request();
    }
  }

  Future<void> request() async {
    final prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('accessToken');
    Response response;
    if (token == null || token == '') {
      Navigator.pushAndRemoveUntil(
        context,
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
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const MyHomePage(
            title: 'home page',
          ),
        ),
            (Route<dynamic> route) => false,
      );
      return;
    }
    final user_id = jwt.payload["id"];
    response = await dio.post('/comment/add', data: {'article_id': widget.id, 'user_id' : user_id, "content" : _commentsTextController.text});
    if (response.data['result'] == 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('user id is empty'),
        ),
      );
    } else if (response.data['result'] == 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('article is empty'),
        ),
      );
    } else if (response.data['result'] == 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('content is empty'),
        ),
      );
    } else {
      await _articlePageController.getComments(context, widget.id);
      setState(() {});
    }
  }


  @override
  void initState() {
    super.initState();
    _articlePageController = ArticlePageController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    loadPage();
  }

  Future loadPage() async {
    await _articlePageController.getArticle(context, widget.id);
    await _articlePageController.getComments(context, widget.id);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final title = _articlePageController.article["title"];
    final content = _articlePageController.article["content"];
    final dateEdit = _articlePageController.article["date_edit"];
    final author = _articlePageController.article["writer"];
    final articleId = _articlePageController.article["id"];
    final articleOwner = _articlePageController.article["owner"];
    var datePublish = "Published: ${_articlePageController.article["date_publish"]}";
    if (dateEdit != null) {
      datePublish += ", edited: $dateEdit";
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: _articlePageController.isLoading ? const CircularProgressIndicator() : Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title),
                  Text(content),
                  Text(datePublish),
                  Text("Article ID: $articleId"),
                  Text("Author: $author"),

                  if(articleOwner)...[Align(
                    alignment: Alignment.bottomRight,
                    child: FloatingActionButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>  EditArticlePage(title: title, id: articleId, content: content)
                        )
                      ),
                      heroTag: "btn1", child: const Icon(Icons.edit)
                    )
                  ),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: FloatingActionButton(
                      onPressed: () => deleteArticle(), 
                      heroTag: "btn2",
                      child: const Icon(Icons.delete)
                    )
                  )],
                  SizedBox(
                      width: 500,
                      child: Row(
                        children: [
                          SizedBox(
                            height: 30,
                            width: 200,
                            child: TextField(
                              controller: _commentsTextController,
                              decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: 'Enter your comment here'
                              ),
                            ),
                          ),
                          FloatingActionButton(
                            onPressed: () => checkComment(),
                            heroTag: "btn3",
                            child: const Icon(Icons.comment),
                          )
                        ],
                      )
                  ),
                  SizedBox(
                    height: 200,
                    child: ListView(
                      padding: const EdgeInsets.all(8),
                      children: <Widget>[
                        Container(
                          height: 50,
                          color: Colors.amber[600],
                          child: const Center(child: Text('Entry A')),
                        ),
                        Container(
                          height: 50,
                          color: Colors.amber[500],
                          child: const Center(child: Text('Entry B')),
                        ),
                        Container(
                          height: 50,
                          color: Colors.amber[100],
                          child: const Center(child: Text('Entry C')),
                        ),
                      ],
                    ),
                  )

                ]
              )
            ),
          ),

        ],
      ),
    );
  }
}
