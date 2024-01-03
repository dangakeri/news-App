// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:news/services/global_methods.dart';
import 'package:reading_time/reading_time.dart';

class NewsModel with ChangeNotifier {
  late String newsId;
  late String sourceName;
  late String authorName;
  late String title;
  late String description;
  late String url;
  late String urlToImage;
  late String publishedAt;
  late String dateToShow;
  late String content;
  late String readingTimeText;
  NewsModel({
    required this.newsId,
    required this.sourceName,
    required this.authorName,
    required this.title,
    required this.description,
    required this.url,
    required this.urlToImage,
    required this.publishedAt,
    required this.dateToShow,
    required this.content,
    required this.readingTimeText,
  });
  factory NewsModel.fromJson(dynamic json) {
    String title = json['title'] ?? '';
    String content = json['content'] ?? '';
    String description = json['description'] ?? '';
    String dateToShow = "";
    if (json["publishedAt"] != null) {
      dateToShow = GlobalMethods.formattedDateText(json["publishedAt"]);
    }
    return NewsModel(
      newsId: json['source']['id'] ?? "",
      sourceName: json['source']['name'] ?? "",
      authorName: json['author'] ?? '',
      title: title,
      description: description,
      url: json['url'] ?? '',
      urlToImage: json['urlToImage'] ??
          'https://i.pinimg.com/564x/50/f4/49/50f44914865276b3832a0b76cad7d6f2.jpg',
      publishedAt: json['publishedAt'] ?? '',
      content: content,
      dateToShow: dateToShow,
      readingTimeText: readingTime(title + description + content).msg,
    );
  }

  static List<NewsModel> newsFromSnapshot(List newSnapshot) {
    return newSnapshot.map((json) {
      return NewsModel.fromJson(json);
    }).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data["newsId"] = newsId;
    data["sourceName"] = sourceName;
    data["authorName"] = authorName;
    data["title"] = title;
    data["description"] = description;
    data["url"] = url;
    data["urlToImage"] = urlToImage;
    data["publishedAt"] = publishedAt;
    data["dateToShow"] = dateToShow;
    data["content"] = content;
    data["readingTimeText"] = readingTimeText;
    return data;
  }
}
