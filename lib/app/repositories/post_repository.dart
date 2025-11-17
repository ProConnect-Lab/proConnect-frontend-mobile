import '../models/post.dart';
import '../models/post_payload.dart';
import '../services/api_service.dart';

class PostRepository {
  PostRepository(this._apiService);

  final ApiService _apiService;

  Future<List<PostModel>> fetchPosts({
    String? query,
    bool onlyMine = false,
  }) async {
    try {
      final response = await _apiService.get(
        '/posts',
        queryParameters: {
          if (query != null && query.isNotEmpty) 'search': query,
          'mine': onlyMine ? '1' : '0',
        },
      );
      final posts = response['posts'] as List;
      return posts
          .map((post) => PostModel.fromJson(post as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return [];
    }
  }

  Future<PostModel> createPost(PostPayload payload) async {
    final response = await _apiService.post('/posts', data: payload.toJson());
    return PostModel.fromJson(response['post'] as Map<String, dynamic>);
  }

  Future<PostModel> updatePost(int id, PostPayload payload) async {
    final response = await _apiService.put(
      '/posts/$id',
      data: payload.toJson(),
    );
    return PostModel.fromJson(response['post'] as Map<String, dynamic>);
  }

  Future<void> deletePost(int id) => _apiService.delete('/posts/$id');
}
