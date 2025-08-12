import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Utility class for common UI helpers and functions
class UiUtils {
  UiUtils._();

  /// Show a snackbar with custom styling
  static void showSnackBar(
    BuildContext context,
    String message, {
    SnackBarType type = SnackBarType.info,
    Duration duration = const Duration(seconds: 3),
  }) {
    final color = switch (type) {
      SnackBarType.success => AppColors.success,
      SnackBarType.error => AppColors.error,
      SnackBarType.warning => AppColors.warning,
      SnackBarType.info => AppColors.info,
    };

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: color,
        duration: duration,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  /// Show a loading dialog
  static void showLoadingDialog(BuildContext context, {String? message}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryGreen),
            ),
            if (message != null) ...[
              const SizedBox(height: 16),
              Text(message),
            ],
          ],
        ),
      ),
    );
  }

  /// Hide any open dialog
  static void hideDialog(BuildContext context) {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
  }

  /// Format currency for Kenyan Shilling
  static String formatCurrency(double amount) {
    return 'KES ${amount.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    )}';
  }

  /// Format phone number for Kenyan format
  static String formatPhoneNumber(String phoneNumber) {
    // Remove any non-digit characters
    String digits = phoneNumber.replaceAll(RegExp(r'\D'), '');
    
    // Handle different formats
    if (digits.startsWith('254')) {
      return '+$digits';
    } else if (digits.startsWith('0')) {
      return '+254${digits.substring(1)}';
    } else if (digits.length == 9) {
      return '+254$digits';
    }
    
    return phoneNumber; // Return original if format is unclear
  }

  /// Validate Kenyan phone number
  static bool isValidKenyanPhoneNumber(String phoneNumber) {
    final formatted = formatPhoneNumber(phoneNumber);
    final regex = RegExp(r'^\+254[17]\d{8}$');
    return regex.hasMatch(formatted);
  }

  /// Get initials from name
  static String getInitials(String name) {
    List<String> names = name.trim().split(' ');
    if (names.length == 1) {
      return names[0].isNotEmpty ? names[0][0].toUpperCase() : '';
    }
    return '${names[0][0]}${names[names.length - 1][0]}'.toUpperCase();
  }

  /// Get time ago string
  static String getTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 7) {
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays == 1 ? '' : 's'} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours == 1 ? '' : 's'} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes == 1 ? '' : 's'} ago';
    } else {
      return 'Just now';
    }
  }

  /// Validate email address
  static bool isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  /// Generate a random color for avatars
  static Color generateAvatarColor(String text) {
    final colors = [
      AppColors.primaryGreen,
      AppColors.mpesaGreen,
      AppColors.terracotta,
      AppColors.savanna,
      AppColors.acacia,
    ];
    
    final hash = text.hashCode;
    return colors[hash.abs() % colors.length];
  }
}

enum SnackBarType {
  success,
  error,
  warning,
  info,
}
