import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../app_config.dart';
import 'article_page_controller.dart';
import 'main.dart';

class EditArticlePage extends StatefulWidget {
  const EditArticlePage({super.key, required this.title});

  final String title;

  @override
  State<EditArticlePage> createState() => _EditArticlePage();
}

class _EditArticlePage extends State<EditArticlePage> {
  final _content = TextEditingController();
  final _title = TextEditingController();

  Dio dio = Dio();
  late ArticlePageController _articlePageControler;
  @override
  void initState() {
    super.initState();
    _articlePageControler = ArticlePageController();
  }

  Future<void> updateArticle() async {
    dio.options.baseUrl = AppConfig.baseUrl;
    Response response;
    response = await dio.post('/article/post',
        data: {'title': _title.text, 'content':_content.text, 'id':_articlePageControler.article["id"]});
    if (response.data['result'] == 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('title/content can not be empty'),
        ),
      );
    } else if(response.data['result'] == 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('article id can not be empty'),
        ),
      );
    } else {
      Navigator.pop(context);
    }
  }

  Future<void> checkInput() async{
    if (_content.text.isEmpty ||
        _title.text.isEmpty) {
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
      await updateArticle();
    }
  }

  @override
  Widget build(BuildContext context) {
    final content = _articlePageControler.article['content'];
    final title = _articlePageControler.article['title'];
    _content.text = content;
    _title.text = title;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme
            .of(context)
            .colorScheme
            .inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Column(
                children: <Widget>[
                  Align(
                    alignment: Alignment.topLeft,
                    child: SizedBox(
                      height: 50,
                      child:TextField(
                        textAlign: TextAlign.left,
                        textAlignVertical: TextAlignVertical.top,
                        controller: _title,
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          labelText: 'Title',
                          hintText: 'Write the article title here'
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: TextField(
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
                ]
              )
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: FloatingActionButton(
                onPressed: () => checkInput(),
                child: const Icon(Icons.save),
              ),
            ),
          ],
        ),
      ),
    );
  }
}