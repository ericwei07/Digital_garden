import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:happy_digital_garden/app_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';

class LinksPageController {
  Map<String, dynamic> result = Map();
  final Dio dio = Dio();
  bool isLoading = true;

  Future getLinkList(BuildContext context) async {
    dio.options.baseUrl = AppConfig.baseUrl;
    final navigator = Navigator.of(context);
    try {
      isLoading = true;
      final prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('accessToken');
      if (token == null || token == '') {
        navigator.pushAndRemoveUntil(
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
        navigator.pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => const MyHomePage(
              title: 'home page',
            ),
          ),
              (Route<dynamic> route) => false,
        );
      }
      final name = jwt.payload["username"];
      final id = jwt.payload["id"];
      final response = await dio.get('/links/get?id=$id');
      result["usernames"] = response.data['usernames'];
      result["links"] = response.data['user_id'];
      result["link_id"] = response.data['link_id'];
    } finally {
      isLoading = false;
    }
  }
}
