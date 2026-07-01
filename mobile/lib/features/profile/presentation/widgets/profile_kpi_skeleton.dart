import 'package:flutter/material.dart';
import '../../../../shared/widgets/skeleton/skeleton_box.dart';

class ProfileKpiSkeleton extends StatelessWidget {
  const ProfileKpiSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _KpiItemSkeleton()),
        Expanded(child: _KpiItemSkeleton()),
      ],
    );
  }
}

class _KpiItemSkeleton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SkeletonBox(width: 60, height: 32),
        const SizedBox(height: 6),
        SkeletonBox(width: 80, height: 14),
      ],
    );
  }
}
