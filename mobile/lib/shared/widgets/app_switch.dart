import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class AppSwitch extends StatelessWidget {
  const AppSwitch({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final bool value;
  final ValueChanged<bool> onChanged;

  static const _trackWidth = 51.0;
  static const _trackHeight = 31.0;
  static const _thumbSize = 25.0;
  static const _padding = (_trackHeight - _thumbSize) / 2;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        width: _trackWidth,
        height: _trackHeight,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(_trackHeight / 2),
          color: value ? AppColors.mainContrast : AppColors.borderSecondary,
        ),
        child: Padding(
          padding: const EdgeInsets.all(_padding),
          child: AnimatedAlign(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            alignment: value ? Alignment.centerRight : Alignment.centerLeft,
            child: Container(
              width: _thumbSize,
              height: _thumbSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
