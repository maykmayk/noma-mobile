import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProfileStreakBanner extends StatelessWidget {
  const ProfileStreakBanner({super.key, required this.rideDays});

  final Set<DateTime> rideDays;

  /// Counts consecutive weeks (rolling 7-day windows starting from today)
  /// that contain at least one ride. Returns 0 if no ride in the last 7 days.
  static int computeStreakWeeks(Set<DateTime> rideDays) {
    if (rideDays.isEmpty) return 0;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    int streak = 0;
    for (var w = 0; ; w++) {
      final end = today.subtract(Duration(days: w * 7));
      final start = end.subtract(const Duration(days: 6));
      final hasRide = rideDays.any((d) => !d.isBefore(start) && !d.isAfter(end));
      if (!hasRide) break;
      streak++;
    }
    return streak;
  }

  @override
  Widget build(BuildContext context) {
    final weeks = computeStreakWeeks(rideDays);
    if (weeks == 0) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _BannerCard(weeks: weeks),
      ],
    );
  }
}

class _BannerCard extends StatelessWidget {
  const _BannerCard({required this.weeks});

  final int weeks;

  static const _gradient = LinearGradient(
    begin: Alignment.topRight,
    end: Alignment.bottomLeft,
    colors: [Color(0xFF5CB270), Color(0xFFF4F269)],
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: _gradient,
      ),
      child: Row(
        children: [
          SvgPicture.asset(
            'assets/icons/ic_flame.svg',
            width: 28,
            height: 28,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'profile.streak.title'.plural(weeks),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'profile.streak.subtitle'.tr(),
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
