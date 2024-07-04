import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:happy_digital_garden/pages/article_page_controller.dart';
import 'package:happy_digital_garden/pages/edit_article_page.dart';

import '../app_config.dart';


class ArticlePage extends StatefulWidget {
  const ArticlePage({super.key, required this.title, required this.id});
  final String title;
  final int id;
  @override
  State<ArticlePage> createState() => _ArticlePage();
}

class _ArticlePage extends State<ArticlePage> {
  late ArticlePageController _articlePageControler;

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


  @override
  void initState() {
    super.initState();
    _articlePageControler = ArticlePageController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    loadPage();
  }

  Future loadPage() async {
    await _articlePageControler.getArticle(context, widget.id);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final title = _articlePageControler.article["title"];
    final content = _articlePageControler.article["content"];
    final dateEdit = _articlePageControler.article["date_edit"];
    final author = _articlePageControler.article["writer"];
    final articleId = _articlePageControler.article["id"];
    final owner = _articlePageControler.article["owner"];
    var datePublish = "Published: ${_articlePageControler.article["date_publish"]}";
    if (dateEdit != null) {
      datePublish += ", edited: $dateEdit";
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: _articlePageControler.isLoading ? const CircularProgressIndicator() : SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(title),
            Text(content),
            Text(datePublish),
            Text("Article ID: $articleId"),
            Text("Author: $author"),
            if(owner) FloatingActionButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) =>  EditArticlePage(title: title, id: articleId, content: content,))), heroTag: "btn1", child: const Icon(Icons.edit)),
            if(owner) FloatingActionButton(onPressed: () => deleteArticle(),heroTag: "btn2", child: const Icon(Icons.delete)),
          ],
        ),
      ),
    );
  }
}
