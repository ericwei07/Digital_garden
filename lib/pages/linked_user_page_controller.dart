import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:happy_digital_garden/app_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';

class LinkedUserPageController {
  Map<String, dynamic> result = Map();
  final Dio dio = Dio();
  bool isLoading = true;

  Future getArticleList(id) async {
    dio.options.baseUrl = AppConfig.baseUrl;
    try {
      isLoading = true;
      final response = await dio.get('/article/list?id=$id');
      result["content"] = response.data['list'];
    } finally {
      isLoading = false;
    }
  }
}
