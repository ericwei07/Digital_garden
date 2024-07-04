import 'package:flutter/material.dart';

import 'article_page.dart';
import 'other_garden_page_controller.dart';

class AllGardenContent extends StatefulWidget {
  const AllGardenContent({super.key, required this.title});
  final String title;

  @override
  State<AllGardenContent> createState() => _AllGardenContent();
}

class _AllGardenContent extends State<AllGardenContent>{
  late OtherGardenPageController _otherGardenPageController;
  @override
  void initState() {
    super.initState();
    _otherGardenPageController = OtherGardenPageController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    loadPage();
  }

  Future loadPage() async {
    await _otherGardenPageController.getGardenList(context);
    setState(() {});
  }


  @override
  Widget build(BuildContext context) {
    final articles = _otherGardenPageController.result["content"];
    return Scaffold(
      body: SingleChildScrollView (
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Row(
              children: <Widget>[
                Text('Newest garden are here'),
              ],
            ),
            ListView.builder(
                itemCount: articles.length,
                itemBuilder: (context, index) {
                  var article = articles[index];
                  String articleTitle = article["title"];
                  int articleId = article["article_id"];
                  return ListTile(
                    title: Text(articleTitle),
                    onTap: () {
                      Navigator.push(context,MaterialPageRoute(builder: (context) => ArticlePage(title: articleTitle, id: articleId)));
                    },
                  );
                }
            ),
          ],
        ),
      ),
    );
  }
}
