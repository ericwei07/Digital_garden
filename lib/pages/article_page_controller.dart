import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:happy_digital_garden/app_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';

class ArticlePageController {
  Map<String ,dynamic> article = Map();
  final Dio dio = Dio();
  bool isLoading = true;
  Future getArticle(BuildContext context, int id) async {
    dio.options.baseUrl = AppConfig.baseUrl;
    try {
      isLoading = true;
      final response = await dio.get('/article/get?id=' + id.toString());
      if (response.data["result"] == 1) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('article does not exist'),
          ),
        );
      } else if (response.data["result"] == 2) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('id can not be empty'),
          ),
        );
      } else {
        article = response.data;
        checkAuthor(context);
      }
    } finally {
      isLoading = false;
    }
  }

  void backToHomePage(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context, MaterialPageRoute(
        builder: (context) => const MyHomePage(title: 'home page',)
    ),
          (Route<dynamic> route) => false,
    );
  }

  Future checkAuthor(BuildContext context) async {
    var prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('accessToken');
    if (token == null || token == '') {
      backToHomePage(context);
      return;
    }
    final jwt = JWT.decode(token);
    final exp = jwt.payload['exp'];
    final expiryDate = DateTime.fromMillisecondsSinceEpoch(exp * 1000);
    final currentTime = DateTime.now();
    if (expiryDate.difference(currentTime).inSeconds < 0) {
      backToHomePage(context);
      return;
    };
    final name = jwt.payload["username"];
    if (name == article["writer"]) {
      article["owner"] = true;
    } else {
      article["owner"] = false;
    }
  }
}

