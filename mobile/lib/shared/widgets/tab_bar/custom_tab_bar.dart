import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../core/theme/app_theme.dart';

class CustomTabBar extends StatelessWidget {
  const CustomTabBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    this.topPadding = 12,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;

  /// Space between the top border and the icon+label group.
  final double topPadding;

  static const _items = [
    _TabItem(label: 'Home', assetPath: 'assets/icons/tab_home.svg'),
    _TabItem(label: 'Ride', assetPath: 'assets/icons/tab_ride.svg'),
    _TabItem(label: 'Profile', assetPath: 'assets/icons/tab_profile.svg'),
  ];

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.white,
        border: Border(
          top: BorderSide(color: AppColors.borderSecondary),
        ),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 64,
          child: Row(
            children: List.generate(_items.length, (i) {
              final active = i == currentIndex;
              final color =
                  active ? AppColors.black : AppColors.textSecondary;
              return Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => onTap(i),
                  child: Padding(
                    padding: EdgeInsets.only(top: topPadding),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SvgPicture.asset(
                          _items[i].assetPath,
                          width: 22,
                          height: 22,
                          colorFilter:
                              ColorFilter.mode(color, BlendMode.srcIn),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _items[i].label,
                          style: TextStyle(
                            fontFamily: 'OpenRunde',
                            fontSize: 13,
                            color: color,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _TabItem {
  const _TabItem({required this.label, required this.assetPath});

  final String label;
  final String assetPath;
}
