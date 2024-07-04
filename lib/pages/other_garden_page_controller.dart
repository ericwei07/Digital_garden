import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:happy_digital_garden/app_config.dart';

class OtherGardenPageController {
  Map<String, dynamic> result = Map();
  final Dio dio = Dio();
  bool isLoading = false;

  Future getGardenList(BuildContext context) async {
    dio.options.baseUrl = AppConfig.baseUrl;
    try {
      isLoading = true;
      final response = await dio.get('/article/list?id=');
      result["content"] = response.data['list'];
    } finally {
      isLoading = false;
    }
  }
}
