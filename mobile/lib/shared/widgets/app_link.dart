import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class AppLink extends StatelessWidget {
  const AppLink({
    super.key,
    required this.text,
    required this.linkText,
    required this.onTap,
  });

  final String text;
  final String linkText;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: RichText(
        text: TextSpan(
          text: text,
          style: const TextStyle(color: AppColors.textSecondary),
          children: [
            TextSpan(
              text: linkText,
              style: const TextStyle(
                color: AppColors.mainContrast,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
