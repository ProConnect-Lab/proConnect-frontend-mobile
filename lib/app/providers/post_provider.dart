import 'package:get/get.dart';

import '../exceptions/app_exception.dart';
import '../models/post.dart';
import '../models/post_payload.dart';
import '../repositories/post_repository.dart';

class PostController extends GetxController {
  PostController(this._repository);

  final PostRepository _repository;

  final RxList<PostModel> posts = <PostModel>[].obs;
  final RxBool _isLoading = false.obs;
  final RxnString _error = RxnString();
  final RxString _currentQuery = ''.obs;
  final RxBool _showOnlyMine = false.obs;

  bool get isLoading => _isLoading.value;
  String? get error => _error.value;
  String get currentQuery => _currentQuery.value;
  bool get showOnlyMine => _showOnlyMine.value;

  Future<void> fetchPosts({String? query, bool? onlyMine}) async {
    _setLoading(true);
    try {
      _currentQuery.value = query ?? '';
      if (onlyMine != null) {
        _showOnlyMine.value = onlyMine;
      }
      final items = await _repository.fetchPosts(
        query: query,
        onlyMine: _showOnlyMine.value,
      );
      posts.assignAll(items);
      _error.value = null;
    } catch (error) {
      _error.value = _formatError(error);
    } finally {
      _setLoading(false);
    }
  }

  void toggleFilter() {
    _showOnlyMine.value = !_showOnlyMine.value;
    fetchPosts();
  }

  Future<bool> createPost(PostPayload payload) async {
    try {
      final post = await _repository.createPost(payload);
      posts.insert(0, post);
      return true;
    } catch (error) {
      _error.value = _formatError(error);
      return false;
    }
  }

  Future<bool> updatePost(int id, PostPayload payload) async {
    try {
      final post = await _repository.updatePost(id, payload);
      final index = posts.indexWhere((item) => item.id == id);
      if (index != -1) {
        posts[index] = post;
      }
      return true;
    } catch (error) {
      _error.value = _formatError(error);
      return false;
    }
  }

  Future<bool> deletePost(int id) async {
    try {
      await _repository.deletePost(id);
      posts.removeWhere((post) => post.id == id);
      return true;
    } catch (error) {
      _error.value = _formatError(error);
      return false;
    }
  }

  void reset() {
    posts.clear();
    _error.value = null;
    _currentQuery.value = '';
    _showOnlyMine.value = false;
    _isLoading.value = false;
  }

  void _setLoading(bool value) {
    _isLoading.value = value;
  }

  String _formatError(Object error) {
    if (error is AppException) {
      return error.message;
    }
    return 'Impossible de charger les publications.';
  }
}
