import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:news/consts/api_consts.dart';
import 'package:news/consts/http_exceptions.dart';
import 'package:news/models/news_model.dart';

import '../models/bookmark_model.dart';

class ApiService {
  static Future<List<NewsModel>> getNews(
      {required int page, required String sortBy}) async {
    try {
      var uri = Uri.https(baseUrl, 'v2/everything', {
        "q": "everything",
        "pageSize": "5",
        "domains": "bbc.co.uk,techcrunch.com,engadget.com",
        "apiKey": apiKey,
        "page": page.toString(),
        "sortBy": sortBy,
      });
      var response = await http.get(uri, headers: {
        "X-Api-key": apiKey,
      });
      // print('Response body: ${response.body}');
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

  static Future<List<NewsModel>> getTopHeadlines() async {
    try {
      var uri = Uri.https(baseUrl, 'v2/top-headlines', {"country": "ke"});
      var response = await http.get(uri, headers: {
        "X-Api-key": apiKey,
      });
      // print('Response body: ${response.body}');
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

  static Future<List<NewsModel>> searchNews({required String query}) async {
    try {
      var uri = Uri.https(baseUrl, "v2/everything", {
        "q": query,
        "pageSize": "5",
        "domains": "techcrunch.com",
      });
      var response = await http.get(
        uri,
        headers: {"X-Api-key": apiKey},
      );

      Map data = jsonDecode(response.body);
      List newsTempList = [];

      if (data['code'] != null) {
        throw HttpException(data['code']);
      }
      for (var v in data["articles"]) {
        newsTempList.add(v);
      }
      return NewsModel.newsFromSnapshot(newsTempList);
    } catch (error) {
      throw error.toString();
    }
  }

  static Future<List<BookmarksModel>?> getBookmarks() async {
    try {
      var uri = Uri.https(baseUrlFirebase, "bookmarks.json");
      var response = await http.get(
        uri,
      );

      Map data = jsonDecode(response.body);
      List allKeys = [];

      if (data['code'] != null) {
        throw HttpException(data['code']);
        // throw data['message'];
      }
      for (String key in data.keys) {
        allKeys.add(key);
      }
      log("allKeys $allKeys");
      return BookmarksModel.bookmarksFromSnapshot(json: data, allKeys: allKeys);
    } catch (error) {
      rethrow;
    }
  }
}
