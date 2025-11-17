import 'dart:convert';
import 'package:get/get.dart';

import '../exceptions/app_exception.dart';
import '../models/auth_payloads.dart';
import '../models/user.dart';
import '../repositories/auth_repository.dart';
import '../services/api_service.dart';
import '../services/storage_service.dart';

class AuthController extends GetxController {
  AuthController(this._repository, this._apiService, this._storageService);

  final AuthRepository _repository;
  final ApiService _apiService;
  final StorageService _storageService;

  final Rxn<AppUser> _user = Rxn<AppUser>();
  final RxnString _token = RxnString();
  final RxnString _error = RxnString();
  final RxBool _isLoading = false.obs;

  AppUser? get user => _user.value;
  String? get error => _error.value;
  bool get isLoading => _isLoading.value;
  bool get isAuthenticated => _token.value != null;

  Future<bool> register(RegisterPayload payload) async {
    _setLoading(true);
    try {
      final session = await _repository.register(payload);
      _applySession(session);
      return true;
    } catch (error) {
      _error.value = _formatError(error);
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> login(LoginPayload payload) async {
    _setLoading(true);
    try {
      final session = await _repository.login(payload);
      _applySession(session);
      return true;
    } catch (error) {
      _error.value = _formatError(error);
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> fetchProfile() async {
    if (_token.value == null) return;

    try {
      final profile = await _repository.profile();
      _user.value = profile;
    } catch (error) {
      _error.value = _formatError(error);
    }
  }

  Future<bool> updateProfile(Map<String, dynamic> data) async {
    try {
      final updatedUser = await _repository.updateProfile(data);
      _user.value = updatedUser;
      _error.value = null;
      return true;
    } catch (error) {
      _error.value = _formatError(error);
      return false;
    }
  }

  Future<void> logout() async {
    _token.value = null;
    _user.value = null;
    _error.value = null;
    _apiService.setToken(null);
    await _storageService.clearAll();
  }

  Future<void> _applySession(AuthSession session) async {
    _token.value = session.token;
    _user.value = session.user;
    _error.value = null;
    _apiService.setToken(session.token);

    // Sauvegarder dans le storage
    await _storageService.saveToken(session.token);
    await _storageService.saveUserData(jsonEncode(session.user.toJson()));
  }

  Future<void> restoreSession() async {
    try {
      final token = await _storageService.getToken();
      final userData = await _storageService.getUserData();

      if (token != null && userData != null) {
        _token.value = token;
        _user.value = AppUser.fromJson(jsonDecode(userData));
        _apiService.setToken(token);

        // Rafraîchir le profil pour avoir les données à jour
        await fetchProfile();
      }
    } catch (e) {
      // En cas d'erreur, nettoyer le storage
      await _storageService.clearAll();
    }
  }

  void _setLoading(bool value) {
    _isLoading.value = value;
  }

  String _formatError(Object error) {
    if (error is AppException) {
      return error.message;
    }
    return 'Une erreur inattendue est survenue.';
  }
}
