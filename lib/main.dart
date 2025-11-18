import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'app/modules/auth/login_module.dart';
import 'app/modules/home/home_module.dart';
import 'app/modules/splash/splash_screen.dart';
import 'app/providers/auth_provider.dart';
import 'app/providers/company_provider.dart';
import 'app/providers/post_provider.dart';
import 'app/repositories/auth_repository.dart';
import 'app/repositories/company_repository.dart';
import 'app/repositories/post_repository.dart';
import 'app/services/api_service.dart';
import 'app/services/storage_service.dart';
import 'common/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final apiService = ApiService();
  final storageService = StorageService();

  Get.put<ApiService>(apiService, permanent: true);
  Get.put<StorageService>(storageService, permanent: true);
  Get.put<AuthRepository>(AuthRepository(apiService));
  Get.put<CompanyRepository>(CompanyRepository(apiService));
  Get.put<PostRepository>(PostRepository(apiService));
  Get.put<AuthController>(
    AuthController(Get.find<AuthRepository>(), apiService, storageService),
  );
  Get.put<CompanyController>(CompanyController(Get.find<CompanyRepository>()));
  Get.put<PostController>(PostController(Get.find<PostRepository>()));

  runApp(const ProConnectApp());
}

class ProConnectApp extends StatefulWidget {
  const ProConnectApp({super.key});

  @override
  State<ProConnectApp> createState() => _ProConnectAppState();
}

class _ProConnectAppState extends State<ProConnectApp> {
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    // Restaurer la session
    await Get.find<AuthController>().restoreSession();

    // Simuler un minimum de temps d'affichage du splash screen
    await Future.delayed(const Duration(milliseconds: 1500));

    if (mounted) {
      setState(() {
        _isInitialized = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();

    return GetMaterialApp(
      title: 'Pro Connect',
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      home:
          !_isInitialized
              ? const SplashScreen()
              : Obx(() {
                return authController.isAuthenticated
                    ? const HomeModule()
                    : const LoginModule();
              }),
    );
  }
}
