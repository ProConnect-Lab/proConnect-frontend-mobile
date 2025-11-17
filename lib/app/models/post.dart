import 'company.dart';

class PostModel {
  PostModel({
    required this.id,
    required this.title,
    required this.content,
    required this.authorName,
    this.company,
  });

  final int id;
  final String title;
  final String content;
  final String authorName;
  final Company? company;

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['id'] as int,
      title: json['title'] as String,
      content: json['content'] as String,
      authorName: json['user'] != null ? json['user']['name'] as String : '',
      company: json['company'] != null
          ? Company.fromJson(json['company'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'user': {'name': authorName},
      'company': company?.toJson(),
    };
  }
}
