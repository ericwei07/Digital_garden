import 'package:flutter/material.dart';
import 'package:happy_digital_garden/pages/article_page.dart';

import 'new_garden_page.dart';
import 'user_garden_page_controller.dart';

class MyGardenContent extends StatefulWidget {
  const MyGardenContent({super.key, required this.title});

  final String title;

  @override
  State<MyGardenContent> createState() => _MyGardenContent();
}

class _MyGardenContent extends State<MyGardenContent> {
  late UserGardenPageController _userGardenPageController;

  @override
  void initState() {
    super.initState();
    _userGardenPageController = UserGardenPageController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    loadPage();
  }

  Future loadPage() async {
    await _userGardenPageController.getGardenList(context);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final username = _userGardenPageController.result['username'];
    final articles = _userGardenPageController.result['content'];
    final gardenName = "$username's garden";
    final gardenContent = "this is $username's garden";
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(gardenName),
      ),
      body: _userGardenPageController.isLoading ? const CircularProgressIndicator() : Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(gardenContent),
            Expanded(
                child: (articles?.length == 0) ? const Text("Your garden is empty, try create a new one") : ListView.builder(
                    itemCount: articles.length,
                    itemBuilder: (context, index) {
                      var article = articles[index];
                      String articleTitle = article["title"];
                      int articleId = article["article_id"];
                      return ListTile(
                        title: Text(articleTitle),
                        onTap: () async {
                          await Navigator.push(
                            context, MaterialPageRoute(
                              builder: (context) => ArticlePage(title: articleTitle, id: articleId)
                            ),
                          );
                          await _userGardenPageController.getGardenList(context);
                          setState(() {});
                        },
                      );
                    }
                ),
            ),

            Align(
              alignment: Alignment.bottomRight,
              child: FloatingActionButton(
                heroTag: null,
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const NewGardenPage(
                        title: 'digital garden',
                      )
                    ),
                  );
                  await _userGardenPageController.getGardenList(context);
                  setState(() {});
                },
                child: const Icon(Icons.add),
              ),
            ),
          ],
        ),
    );
  }
}
