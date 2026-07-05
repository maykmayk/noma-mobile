import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class AppRadioButton extends StatelessWidget {
  const AppRadioButton({
    super.key,
    required this.selected,
    this.onTap,
    this.size = 22.0,
  });

  final bool selected;
  final VoidCallback? onTap;
  final double size;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeInOut,
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: selected ? AppColors.mainContrast : Colors.transparent,
          border: Border.all(
            color: selected ? AppColors.mainContrast : AppColors.border,
            width: 1.5,
          ),
        ),
        child: selected
            ? Center(
                child: Container(
                  width: size * 0.38,
                  height: size * 0.38,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.white,
                  ),
                ),
              )
            : null,
      ),
    );
  }
}
