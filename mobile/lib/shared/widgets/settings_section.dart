import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../core/theme/app_theme.dart';

/// Labeled group of [SettingsItem] rows inside a rounded card.
class SettingsSection extends StatelessWidget {
  const SettingsSection({
    super.key,
    required this.label,
    required this.items,
  });

  final String label;
  final List<SettingsItem> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: AppColors.lightBg,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(children: items),
        ),
      ],
    );
  }
}

/// Single tappable row inside a [SettingsSection].
///
/// Shows [icon] on the left, [title] in the middle, chevron-right on the right.
/// Set [isLast] to true on the final item to suppress the bottom divider.
class SettingsItem extends StatelessWidget {
  const SettingsItem({
    super.key,
    required this.icon,
    required this.title,
    this.isLast = false,
    this.onTap,
  });

  final String icon;
  final String title;
  final bool isLast;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          behavior: HitTestBehavior.opaque,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: Row(
              children: [
                SvgPicture.asset(icon, width: 20, height: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.mainContrast,
                    ),
                  ),
                ),
                SvgPicture.asset(
                  'assets/icons/ic_chevron_right.svg',
                  width: 20,
                  height: 20,
                ),
              ],
            ),
          ),
        ),
        if (!isLast)
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Divider(height: 0, thickness: 1, color: AppColors.border),
          ),
      ],
    );
  }
}
