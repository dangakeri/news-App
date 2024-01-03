import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:news/consts/api_consts.dart';
import 'package:news/consts/http_exceptions.dart';
import 'package:news/models/news_model.dart';

class ApiService {
  // static Future<http.Response> getNews() async {
  static Future<List<NewsModel>> getNews() async {
    try {
      // var url = Uri.parse(
      //     'https://newsapi.org/v2/everything?q=keyword&pageSize=5&apiKey=edecb9b08fce46f2b8dafe3e08bbaa07');
      var uri = Uri.https(baseUrl, 'v2/everything', {
        "q": "bitcoin",
        "pageSize": "5",
        "domains": "bbc.co.uk,techcrunch.com,engadget.com",
        // "apiKey": apiKey,
      });
      var response = await http.get(uri, headers: {
        "X-Api-key": apiKey,
      });
      print('Response body: ${response.body}');
      // return response;
      Map data = jsonDecode(response.body);
      List newsTempList = [];

      if (data['code'] != null) {
        throw HttpException(data['code']);
      }

      for (var v in data['articles']) {
        newsTempList.add(v);
      }
      return NewsModel.newsFromSnapshot(newsTempList);
    } catch (error) {
      throw error.toString();
    }
  }
}
