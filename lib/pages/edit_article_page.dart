import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../app_config.dart';

class EditArticlePage extends StatefulWidget {
  const EditArticlePage({super.key, required this.title, required this.id, required this.content});

  final int id;
  final String title;
  final String content;

  @override
  State<EditArticlePage> createState() => _EditArticlePage();
}

class _EditArticlePage extends State<EditArticlePage> {
  final _content = TextEditingController();
  final _title = TextEditingController();

  Dio dio = Dio();

  Future<void> updateArticle() async {
    dio.options.baseUrl = AppConfig.baseUrl;
    Response response;
    response = await dio.post('/article/update', data: {'title': _title.text, 'content': _content.text, 'id': widget.id});
    if (response.data['result'] == 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('title/content can not be empty'),
        ),
      );
    } else if (response.data['result'] == 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('article id can not be empty'),
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
      await updateArticle();
    }
  }

  @override
  Widget build(BuildContext context) {
    final content = widget.content;
    final title = widget.title;
    _content.text = content;
    _title.text = title;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Edit article"),
      ),
      body:Stack(
        children: [
          Container(
            margin: const EdgeInsets.only(left: 30, right: 30, top: 10),
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
    );
  }
}
