import 'package:flutter/material.dart';
import 'package:happy_digital_garden/pages/article_page.dart';

import 'linked_user_page_controller.dart';

class LinkedUserPage extends StatefulWidget {
  const LinkedUserPage({super.key, required this.id, required this.username});

  final int id;
  final String username;

  @override
  State<LinkedUserPage> createState() => _LinkedUserPage();
}

class _LinkedUserPage extends State<LinkedUserPage> {
  late LinkedUserPageController _LinkedUserPageController;

  @override
  void initState() {
    super.initState();
    _LinkedUserPageController = LinkedUserPageController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    loadPage();
  }

  Future loadPage() async {
    await _LinkedUserPageController.getArticleList(widget.id);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final username = widget.username;
    final articles = _LinkedUserPageController.result['content'];
    final gardenName = "$username's garden";
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("$username's garden"),
      ),
      body: _LinkedUserPageController.isLoading ? const CircularProgressIndicator() : Column(
        children: [
          Expanded(
            child: (articles?.length == 0) ? Text("${widget.username}'s garden is empty") : ListView.builder(
              itemCount: articles.length,
              itemBuilder: (context, index) {
                var article = articles[index];
                String articleTitle = article["title"];
                int articleId = article["article_id"];
                return ListTile(
                  title: Text(articleTitle),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ArticlePage(title: articleTitle, id: articleId)),
                    );
                  },
                );
              }
            ),
          )
        ],
      )
    );
  }
}
