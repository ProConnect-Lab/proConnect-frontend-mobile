import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../theme/app_theme.dart';

enum MessageType { success, error, warning, info }

class ErrorHandler {
  static void showSnackbar({
    required String message,
    MessageType type = MessageType.info,
    Duration duration = const Duration(seconds: 4),
  }) {
    Color backgroundColor;
    IconData icon;

    switch (type) {
      case MessageType.success:
        backgroundColor = AppTheme.accentColor;
        icon = Icons.check_circle_outline;
        break;
      case MessageType.error:
        backgroundColor = AppTheme.errorColor;
        icon = Icons.error_outline;
        break;
      case MessageType.warning:
        backgroundColor = AppTheme.warningColor;
        icon = Icons.warning_amber_outlined;
        break;
      case MessageType.info:
        backgroundColor = AppTheme.primaryColor;
        icon = Icons.info_outline;
        break;
    }

    Get.showSnackbar(
      GetSnackBar(
        message: message,
        duration: duration,
        backgroundColor: backgroundColor,
        borderRadius: 12,
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        icon: Icon(icon, color: Colors.white, size: 28),
        snackPosition: SnackPosition.TOP,
        isDismissible: true,
        dismissDirection: DismissDirection.horizontal,
        animationDuration: const Duration(milliseconds: 300),
      ),
    );
  }

  static void showErrorSnackbar(String message) {
    showSnackbar(message: message, type: MessageType.error);
  }

  static void showSuccessSnackbar(String message) {
    showSnackbar(message: message, type: MessageType.success);
  }

  static void showWarningSnackbar(String message) {
    showSnackbar(message: message, type: MessageType.warning);
  }

  static void showInfoSnackbar(String message) {
    showSnackbar(message: message, type: MessageType.info);
  }

  static Future<bool?> showConfirmDialog({
    required String title,
    required String message,
    String confirmText = 'Confirmer',
    String cancelText = 'Annuler',
    bool isDangerous = false,
  }) async {
    return Get.dialog<bool>(
      AlertDialog(
        title: Row(
          children: [
            Icon(
              isDangerous ? Icons.warning_amber : Icons.help_outline,
              color: isDangerous ? AppTheme.warningColor : AppTheme.primaryColor,
            ),
            const SizedBox(width: 12),
            Expanded(child: Text(title)),
          ],
        ),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: Text(cancelText),
          ),
          ElevatedButton(
            onPressed: () => Get.back(result: true),
            style: isDangerous
                ? ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.errorColor,
                  )
                : null,
            child: Text(confirmText),
          ),
        ],
      ),
    );
  }
}

// Widget pour afficher un état vide
class EmptyStateWidget extends StatelessWidget {
  const EmptyStateWidget({
    super.key,
    required this.message,
    this.icon = Icons.inbox_outlined,
    this.actionLabel,
    this.onAction,
  });

  final String message;
  final IconData icon;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 80,
              color: AppTheme.textDisabledColor,
            ),
            const SizedBox(height: 16),
            Text(
              message,
              style: const TextStyle(
                color: AppTheme.textSecondaryColor,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: onAction,
                icon: const Icon(Icons.add),
                label: Text(actionLabel!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// Widget pour afficher un état d'erreur
class ErrorStateWidget extends StatelessWidget {
  const ErrorStateWidget({
    super.key,
    required this.message,
    this.onRetry,
  });

  final String message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline,
              size: 80,
              color: AppTheme.errorColor,
            ),
            const SizedBox(height: 16),
            Text(
              message,
              style: const TextStyle(
                color: AppTheme.textPrimaryColor,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text('Réessayer'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// Widget de chargement personnalisé
class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key, this.message});

  final String? message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(),
          if (message != null) ...[
            const SizedBox(height: 16),
            Text(
              message!,
              style: const TextStyle(
                color: AppTheme.textSecondaryColor,
                fontSize: 14,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
