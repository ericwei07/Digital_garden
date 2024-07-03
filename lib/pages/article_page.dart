import 'package:flutter/material.dart';
import 'package:happy_digital_garden/pages/article_page_controller.dart';
import 'package:happy_digital_garden/pages/edit_article_page.dart';


class ArticlePage extends StatefulWidget {
  const ArticlePage({super.key, required this.title, required this.id});
  final String title;
  final int id;
  @override
  State<ArticlePage> createState() => _ArticlePage();
}

class _ArticlePage extends State<ArticlePage> {
  late ArticlePageController _articlePageControler;
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
    final author = _articlePageControler.article["author"];
    final articleId = _articlePageControler.article["id"];
    final owner = _articlePageControler.article["owner"];
    var datePublish = _articlePageControler.article["date_publish"];
    if (!dateEdit.isNull) {
      datePublish += _articlePageControler.article["date_publish"] + " edited: " + dateEdit;
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(

        child: Column(
          children: <Widget>[
            Text(
              title,
              style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 2.0)
            ),
            Text(content),
            Row(
              children: [
                Text(datePublish),
                Text(articleId)
              ],
            ),
            Text(
              "Author: $author",
                style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 1.5)
            ),
            if(owner) FloatingActionButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const EditArticlePage(title: 'digital garden')),)),
          ],
        ),
      ),
    );
  }
}
