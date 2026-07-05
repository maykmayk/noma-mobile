import 'package:flutter/material.dart';
import '../../../../shared/widgets/skeleton/skeleton_box.dart';

class ProfileStreakBannerSkeleton extends StatelessWidget {
  const ProfileStreakBannerSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 32),
        SkeletonBox(width: double.infinity, height: 64, borderRadius: 16),
      ],
    );
  }
}
