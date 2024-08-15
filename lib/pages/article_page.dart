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

  Future<void> showDialogueArticle() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Are you sure you want to delete this article'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () async {
                Navigator.of(context).pop();
                await deleteArticle();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> showDialogueComment(id) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Are you sure you want to delete this comment'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () async {
                Navigator.of(context).pop();
                await deleteComment(id);
              },
            ),
          ],
        );
      },
    );
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

    if (dateEdit != null) {
      datePublish += ", edited: $dateEdit";
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: _articlePageController.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(left: 90, right: 90, top: 10),
                  child: CustomScrollView(
                    slivers: [
                      SliverToBoxAdapter(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: MediaQuery.sizeOf(context).width,
                              child: Text(
                                title,
                                textAlign: TextAlign.center,
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.sizeOf(context).width,
                              child: Text(
                                content,
                                textAlign: TextAlign.left,
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.sizeOf(context).width,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 5,),
                                  Text(datePublish),
                                  Text("Article ID: $articleId"),
                                  Text("Author: $author"),
                                ],
                              ),
                            ),
                            Container(
                              height: 50,
                              width: MediaQuery.sizeOf(context).width,
                              padding: const EdgeInsets.only(top: 10),
                              child: TextField(
                                controller: _commentsTextController,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: 'Enter your comment here',
                                ),
                              ),
                            ),
                            Container(
                              height: 30,
                              width: MediaQuery.sizeOf(context).width,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.black38)
                              ),
                              child: TextButton(
                                onPressed: () => checkComment(),
                                child: const Text("Comment"),
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (comments?.isNotEmpty ?? false)
                        SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (BuildContext context, int index) {
                              var comment = comments[index];
                              var comment_author = commentAuthors[index];
                              var comment_id = comments[index]['comment_id'];
                              return Container(
                                margin: const EdgeInsets.all(10.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(comment['content']),
                                    Text("Author: $comment_author"),
                                    if (_articlePageController.comments['owner'][index])Container(
                                      width: MediaQuery.sizeOf(context).width,
                                      margin: const EdgeInsets.only(left: 50, right: 50),
                                      child: ElevatedButton(
                                        onPressed: () async {
                                          await showDialogueComment(comment_id);
                                        },
                                        child: const Text("Delete comment"),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                            childCount: comments.length,
                          ),
                        )
                      else const SliverToBoxAdapter(
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            "there aren't any comments yet",
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          if (articleOwner) Container(
            margin: const EdgeInsets.all(20),
            alignment: Alignment.bottomRight,
            child: FloatingActionButton(
              onPressed: () async {
                await Navigator.push(context,
                  MaterialPageRoute(
                    builder: (context) => EditArticlePage(
                      title: title,
                      id: articleId,
                      content: content
                    ),
                  ),
                );
                await _articlePageController.getArticle(context, widget.id);
                setState(() {});
              },
              heroTag: "btn1",
              child: const Icon(Icons.edit),
            ),
          ),
          if (articleOwner) Container(
            margin: const EdgeInsets.all(20),
            alignment: Alignment.bottomLeft,
            child: FloatingActionButton(
              onPressed: () => showDialogueArticle(),
              heroTag: "btn2",
              child: const Icon(Icons.delete),
            ),
          ),
        ],
      ),
    );
  }
}

