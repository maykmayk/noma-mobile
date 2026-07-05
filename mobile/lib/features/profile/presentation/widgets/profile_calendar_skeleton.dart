import 'package:flutter/material.dart';
import '../../../../shared/widgets/skeleton/skeleton_box.dart';

class ProfileCalendarSkeleton extends StatelessWidget {
  const ProfileCalendarSkeleton({super.key});

  // Matches the rendered height of ProfileCalendar:
  // padding 18×2 + header 20 + gap 14 + day-names 14 + gap 4 + grid (5 rows × 40) = 288
  static const double _height = 288;

  @override
  Widget build(BuildContext context) {
    return SkeletonBox(
      width: double.infinity,
      height: _height,
      borderRadius: 16,
    );
  }
}
