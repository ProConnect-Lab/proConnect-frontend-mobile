import 'package:dio/dio.dart';

import '../../common/constants.dart';
import '../exceptions/app_exception.dart';

class ApiService {
  ApiService({Dio? client})
    : _client =
          client ??
          Dio(
            BaseOptions(
              baseUrl: AppConfig.apiBaseUrl,
              connectTimeout: const Duration(seconds: 10),
              receiveTimeout: const Duration(seconds: 10),
              contentType: Headers.jsonContentType,
              responseType: ResponseType.json,
            ),
          );

  final Dio _client;
  String? _token;

  void setToken(String? token) {
    _token = token;
  }

  Future<dynamic> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _client.get<dynamic>(
        path,
        queryParameters: queryParameters,
        options: _options(),
      );
      return response.data;
    } on DioException catch (error) {
      throw _mapException(error);
    }
  }

  Future<dynamic> post(String path, {Map<String, dynamic>? data}) async {
    try {
      final response = await _client.post<dynamic>(
        path,
        data: data,
        options: _options(),
      );
      return response.data;
    } on DioException catch (error) {
      throw _mapException(error);
    }
  }

  Future<dynamic> put(String path, {Map<String, dynamic>? data}) async {
    try {
      final response = await _client.put<dynamic>(
        path,
        data: data,
        options: _options(),
      );
      return response.data;
    } on DioException catch (error) {
      throw _mapException(error);
    }
  }

  Future<void> delete(String path) async {
    try {
      await _client.delete<void>(path, options: _options());
    } on DioException catch (error) {
      throw _mapException(error);
    }
  }

  Options _options() {
    final headers = <String, String>{'Accept': 'application/json'};

    if (_token != null) {
      headers['Authorization'] = 'Bearer $_token';
    }

    return Options(headers: headers);
  }

  AppException _mapException(DioException error) {
    final statusCode = error.response?.statusCode;
    final serverMessage =
        error.response?.data is Map
            ? (error.response!.data['message'] as String?)
            : error.message;

    return AppException(
      message: _localizeMessage(
        statusCode: statusCode,
        serverMessage: serverMessage,
        type: error.type,
      ),
      statusCode: statusCode,
    );
  }

  String _localizeMessage({
    int? statusCode,
    String? serverMessage,
    DioExceptionType? type,
  }) {
    final trimmed = serverMessage?.trim();
    final normalized = trimmed?.toLowerCase();

    final accentRegex = RegExp(r'[àâäæçéèêëîïôœùûüÿ]');
    if (trimmed != null &&
        trimmed.isNotEmpty &&
        accentRegex.hasMatch(trimmed.toLowerCase())) {
      return trimmed;
    }

    if (type == DioExceptionType.connectionTimeout ||
        type == DioExceptionType.sendTimeout ||
        type == DioExceptionType.receiveTimeout) {
      return 'Temps de réponse dépassé. Vérifiez votre connexion internet.';
    }

    if (type == DioExceptionType.connectionError) {
      return 'Connexion impossible au serveur. Vérifiez votre accès internet.';
    }

    if (type == DioExceptionType.badCertificate) {
      return 'Connexion sécurisée refusée. Certificat invalide.';
    }

    if (type == DioExceptionType.cancel) {
      return 'Requête annulée.';
    }

    if (normalized != null) {
      if (normalized.contains('credentials')) {
        return 'Identifiants incorrects. Veuillez réessayer.';
      }
      if (normalized.contains('unauthenticated')) {
        return 'Authentification requise. Merci de vous reconnecter.';
      }
      if (normalized.contains('forbidden')) {
        return 'Accès refusé. Vos droits sont insuffisants.';
      }
      if (normalized.contains('not found')) {
        return 'La ressource demandée est introuvable.';
      }
      if (normalized.contains('invalid') ||
          normalized.contains('data was invalid')) {
        return 'Certaines données sont invalides. Vérifiez les champs requis.';
      }
      if (normalized.contains('server error')) {
        return 'Erreur interne du serveur. Réessayez plus tard.';
      }
      if (normalized.contains('timeout')) {
        return 'Temps de réponse dépassé. Vérifiez votre connexion internet.';
      }
    }

    switch (statusCode) {
      case 400:
        return 'Requête invalide. Vérifiez les informations envoyées.';
      case 401:
        return 'Session expirée ou identifiants invalides.';
      case 403:
        return 'Vous n’avez pas l’autorisation d’effectuer cette action.';
      case 404:
        return 'La ressource demandée est introuvable.';
      case 409:
        return 'Conflit détecté. Cette ressource existe déjà.';
      case 422:
        return 'Données invalides. Merci de vérifier le formulaire.';
      case 429:
        return 'Trop de requêtes. Merci de patienter quelques instants.';
      case 500:
      case 502:
      case 503:
      case 504:
        return 'Erreur serveur. Veuillez réessayer plus tard.';
      default:
        break;
    }

    if (trimmed != null && trimmed.isNotEmpty) {
      return trimmed;
    }

    return 'Une erreur inattendue est survenue. Veuillez réessayer.';
  }
}
