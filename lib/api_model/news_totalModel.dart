

class NewsModel {
  final int totalArticles;
  final List<ArticleModel> articles;

  NewsModel({
    required this.totalArticles,
    required this.articles,
  });

  factory NewsModel.fromJson(Map<String, dynamic> json) {
    return NewsModel(
      totalArticles: json['totalArticles'] ?? 0,
      articles: List<ArticleModel>.from((json['articles'] as List)
          .map((article) => ArticleModel.fromJson(article))),
    );
  }
}

class ArticleModel {
  final String title;
  final String description;
  final String content;
  final String url;
  final String image;
  final String publishedAt;
  final SourceModel source;

  ArticleModel({
    required this.title,
    required this.description,
    required this.content,
    required this.url,
    required this.image,
    required this.publishedAt,
    required this.source,
  });

  factory ArticleModel.fromJson(Map<String, dynamic> json) {
    return ArticleModel(
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      content: json['content'] ?? '',
      url: json['url'] ?? '',
      image: json['image'] ?? '',
      publishedAt: json['publishedAt'] ?? '',
      source: SourceModel.fromJson(json['source']),
    );
  }
}

class SourceModel {
  final String name;
  final String url;

  SourceModel({
    required this.name,
    required this.url,
  });

  factory SourceModel.fromJson(Map<String, dynamic> json) {
    return SourceModel(
      name: json['name'] ?? '',
      url: json['url'] ?? '',
    );
  }
}
