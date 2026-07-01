import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/profile_stats.dart';

class ProfileKpi extends StatelessWidget {
  const ProfileKpi({super.key, required this.stats});

  final ProfileStats stats;

  @override
  Widget build(BuildContext context) {
    final km = stats.kmTravelled;
    final kmLabel = km >= 1000
        ? '${(km / 1000).toStringAsFixed(1)}k'
        : km.toStringAsFixed(1);

    return Row(
      children: [
        Expanded(child: _KpiItem(value: '${stats.ridesCount}', label: 'rides')),
        Expanded(child: _KpiItem(value: kmLabel, label: 'km travelled')),
      ],
    );
  }
}

class _KpiItem extends StatelessWidget {
  const _KpiItem({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: AppColors.mainContrast,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}
