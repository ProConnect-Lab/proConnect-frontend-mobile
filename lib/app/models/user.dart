import 'company.dart';
import 'post.dart';

class AppUser {
  AppUser({
    required this.id,
    required this.name,
    required this.email,
    required this.accountType,
    required this.address,
    this.companies = const [],
    this.posts = const [],
  });

  final int id;
  final String name;
  final String email;
  final String accountType;
  final String address;
  final List<Company> companies;
  final List<PostModel> posts;

  factory AppUser.fromJson(Map<String, dynamic> json) {
    final companiesJson = json['companies'] as List<dynamic>? ?? [];
    final postsJson = json['posts'] as List<dynamic>? ?? [];

    return AppUser(
      id: json['id'] as int,
      name: json['name'] as String,
      email: json['email'] as String,
      accountType: json['account_type'] as String,
      address: json['address'] as String,
      companies: companiesJson
          .map((company) => Company.fromJson(company as Map<String, dynamic>))
          .toList(),
      posts: postsJson
          .map((post) => PostModel.fromJson(post as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'account_type': accountType,
      'address': address,
      'companies': companies.map((c) => c.toJson()).toList(),
      'posts': posts.map((p) => p.toJson()).toList(),
    };
  }

  AppUser copyWith({
    List<Company>? companies,
    List<PostModel>? posts,
  }) {
    return AppUser(
      id: id,
      name: name,
      email: email,
      accountType: accountType,
      address: address,
      companies: companies ?? this.companies,
      posts: posts ?? this.posts,
    );
  }
}
