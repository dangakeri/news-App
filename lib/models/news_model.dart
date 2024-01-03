// ignore_for_file: public_member_api_docs, sort_constructors_first
class NewsModel {
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
    return NewsModel(
      newsId: json['source']['id'] ?? "",
      sourceName: json['source']['name'] ?? "",
      authorName: json['author'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      url: json['url'] ?? '',
      urlToImage: json['urlToImage'] ?? '',
      publishedAt: json['publishedAt'] ?? '',
      content: json['content'] ?? '',
      dateToShow: 'dateToShow',
      readingTimeText: 'readingTimeText',
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
