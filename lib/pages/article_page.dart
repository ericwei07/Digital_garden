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


  Future<void> deleteArticle() async {
    Response response;
    response = await dio.delete('/article/delete?id=${widget.id}');
    if (response.data['result'] == 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('id can not be empty'),
        ),
      );
    } else {
      Navigator.of(context).pop();
    }
  }

  Future<void> deleteComment(id) async {
    Response response;
    response = await dio.delete('/comment/delete?id=$id');
    if (response.data['result'] == 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('id can not be empty'),
        ),
      );
    } else {
      await _articlePageController.getComments(context, widget.id);
      setState(() {});
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
      _commentsTextController.text = '';
    }
  }

  Dio dio = Dio();

  @override
  void initState() {
    super.initState();
    dio.options.baseUrl = AppConfig.baseUrl;
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
    final comments = _articlePageController.comments['content'];
    final commentAuthors = _articlePageController.comments['author_names'];
    // final commentIds = _articlePageController.comments['comment_id'];
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
                      onPressed: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>  EditArticlePage(title: title, id: articleId, content: content)
                          )
                        );
                        await _articlePageController.getArticle(context, widget.id);
                        setState(() {});
                      },
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
                  (comments?.length == 0) ? const Text("there isn't any comments yet") : SizedBox(
                    height: 200,
                    child: ListView.builder(
                      itemCount: comments.length,
                      itemBuilder: (BuildContext context, int index) {
                        var comment = comments[index];
                        var comment_author = commentAuthors[index];
                        var comment_id = comments[index]['comment_id'];
                        return Container(
                          margin: const EdgeInsets.all(10.0),
                          child: Column(
                            children: [
                              Text(comment_author),
                              Text(comment['content']),
                              if (_articlePageController.comments['owner'][index]) ElevatedButton(
                                onPressed: () async{
                                  await deleteComment(comment_id);
                                },
                                child: const Text("Delete comment")
                              )
                            ],
                          ),
                        );
                      },
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
