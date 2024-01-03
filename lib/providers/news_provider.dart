import 'package:flutter/material.dart';
import 'package:news/apiservices/api_services.dart';
import 'package:news/models/news_model.dart';

class NewsProvider extends ChangeNotifier {
  List<NewsModel> newsList = [];

  List<NewsModel> get getNewsList => newsList;

  Future<List<NewsModel>> fetchAllNews() async {
    newsList = await ApiService.getNews();
    return newsList;
  }
}
