import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';

import '../apiservices/api_services.dart';
import '../consts/api_consts.dart';

import 'package:http/http.dart' as http;

import '../models/bookmark_model.dart';
import '../models/news_model.dart';

class BookmarksProvider with ChangeNotifier {
  List<BookmarksModel> bookmarkList = [];

  List<BookmarksModel> get getBookmarkList {
    return bookmarkList;
  }

  Future<List<BookmarksModel>> fetchBookmarks() async {
    bookmarkList = await ApiService.getBookmarks() ?? [];
    // notifyListeners();
    return bookmarkList;
  }

  Future<void> addToBookmark({required NewsModel newsModel}) async {
    try {
      var uri = Uri.https(baseUrlFirebase, "bookmarks.json");
      var response = await http.post(uri,
          body: json.encode(
            newsModel.toJson(),
          ));
      log('Response status: ${response.statusCode}');
      log('Response body: ${response.body}');
    } catch (error) {
      rethrow;
    }
  }

  Future<void> deleteBookmark() async {
    try {
      var uri =
          Uri.https(baseUrlFirebase, "bookmarks/-N5au6MPr6UbBxbgDKN0.json");
      var response = await http.delete(uri);
      log('Response status: ${response.statusCode}');
      log('Response body: ${response.body}');
    } catch (error) {
      rethrow;
    }
  }
}
