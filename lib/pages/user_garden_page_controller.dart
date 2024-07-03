import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:happy_digital_garden/app_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'main.dart';

class UserGardenPageController {
  Map<String ,dynamic> result = Map();
  final Dio dio = Dio();
  bool isLoading = false;
  Future getGardenList(BuildContext context) async {
    dio.options.baseUrl = AppConfig.baseUrl;
    try {
      isLoading = true;
      final prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('accessToken');
      if (token == null || token == '') {
        Navigator.pushAndRemoveUntil(
          context, MaterialPageRoute(
            builder: (context) => const MyHomePage(title: 'home page',)
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
        Navigator.pushAndRemoveUntil(
          context, MaterialPageRoute(
            builder: (context) => const MyHomePage(title: 'home page',)
        ),
              (Route<dynamic> route) => false,
        );
      };
      final name = jwt.payload["username"];
      final id = jwt.payload["id"];
      final response = await dio.get('/article/list?id=$id');
      result["username"] = name;
      result["content"] = response.data['list'];
    } finally {
      isLoading = false;
    }

  }
}



