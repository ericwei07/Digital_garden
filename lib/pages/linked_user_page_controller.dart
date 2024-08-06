import 'package:dio/dio.dart';
import 'package:happy_digital_garden/app_config.dart';

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
