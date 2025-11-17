import '../models/auth_payloads.dart';
import '../models/user.dart';
import '../services/api_service.dart';

class AuthSession {
  AuthSession({required this.token, required this.user});

  final String token;
  final AppUser user;
}

class AuthRepository {
  AuthRepository(this._apiService);

  final ApiService _apiService;

  Future<AuthSession> register(RegisterPayload payload) async {
    final response = await _apiService.post('/register', data: payload.toJson());
    return AuthSession(
      token: response['token'] as String,
      user: AppUser.fromJson(response['user'] as Map<String, dynamic>),
    );
  }

  Future<AuthSession> login(LoginPayload payload) async {
    final response = await _apiService.post('/login', data: payload.toJson());
    return AuthSession(
      token: response['token'] as String,
      user: AppUser.fromJson(response['user'] as Map<String, dynamic>),
    );
  }

  Future<AppUser> profile() async {
    final response = await _apiService.get('/profile');
    return AppUser.fromJson(response['user'] as Map<String, dynamic>);
  }

  Future<AppUser> updateProfile(Map<String, dynamic> data) async {
    final response = await _apiService.put('/profile', data: data);
    return AppUser.fromJson(response['user'] as Map<String, dynamic>);
  }
}
