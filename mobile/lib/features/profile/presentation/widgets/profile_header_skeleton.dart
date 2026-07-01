import 'package:flutter/material.dart';
import '../../../../shared/widgets/skeleton/skeleton_box.dart';

class ProfileHeaderSkeleton extends StatelessWidget {
  const ProfileHeaderSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SkeletonBox(width: 80, height: 80, borderRadius: 40),
        const SizedBox(height: 16),
        SkeletonBox(width: 140, height: 20),
        const SizedBox(height: 8),
        SkeletonBox(width: 200, height: 16),
      ],
    );
  }
}
