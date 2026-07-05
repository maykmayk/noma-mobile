import 'package:easy_localization/easy_localization.dart';
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

  static const _assetPaths = [
    'assets/icons/tab_home.svg',
    'assets/icons/tab_ride.svg',
    'assets/icons/tab_profile.svg',
  ];

  @override
  Widget build(BuildContext context) {
    final labels = [
      'common.nav.home'.tr(),
      'common.nav.ride'.tr(),
      'common.nav.profile'.tr(),
    ];

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
            children: List.generate(_assetPaths.length, (i) {
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
                          _assetPaths[i],
                          width: 22,
                          height: 22,
                          colorFilter:
                              ColorFilter.mode(color, BlendMode.srcIn),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          labels[i],
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
