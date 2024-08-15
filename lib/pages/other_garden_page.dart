import 'package:flutter/material.dart';

import 'article_page.dart';
import 'other_garden_page_controller.dart';

class AllGardenContent extends StatefulWidget {
  const AllGardenContent({super.key, required this.title});

  final String title;

  @override
  State<AllGardenContent> createState() => _AllGardenContent();
}

class _AllGardenContent extends State<AllGardenContent> {
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
      body: _otherGardenPageController.isLoading ? const CircularProgressIndicator() : Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                margin: const EdgeInsets.all(10),
                child: Text(
                  'Newest articles are here',
                  style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 2.0),
                ),
              ),
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: articles.length,
              itemBuilder: (context, index) {
                var article = articles[index];
                String articleTitle = article["title"];
                int articleId = article["article_id"];
                return ListTile(
                  title: Text(articleTitle),
                  onTap: () async {
                    await Navigator.push(context, MaterialPageRoute(builder: (context) => ArticlePage(title: articleTitle, id: articleId)));
                    await _otherGardenPageController.getGardenList(context);
                    setState(() {});
                  },
                );
              }
            ),
          ),
        ],
      ),
    );
  }
}
