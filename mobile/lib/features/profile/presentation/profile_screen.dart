import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '../../../shared/widgets/page_header.dart';
import '../../../core/theme/app_theme.dart';
import '../../auth/presentation/auth_notifier.dart';
import '../domain/profile_stats.dart';
import 'profile_providers.dart';
import 'widgets/profile_calendar.dart';
import 'widgets/profile_calendar_skeleton.dart';
import 'widgets/profile_header.dart';
import 'widgets/profile_header_skeleton.dart';
import 'widgets/profile_kpi.dart';
import 'widgets/profile_kpi_skeleton.dart';
import 'widgets/profile_streak_banner.dart';
import 'widgets/profile_streak_banner_skeleton.dart';

const _zeroStats = ProfileStats(ridesCount: 0, kmTravelled: 0);

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.paddingOf(context).top;
    final user = ref.watch(currentUserProvider);
    final profileAsync = ref.watch(currentProfileProvider);
    final statsAsync = ref.watch(profileStatsProvider);
    final rideDatesAsync = ref.watch(rideDatesProvider);
    final isSigningOut = ref.watch(authNotifierProvider).isLoading;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PageHeader(
        title: 'profile.title'.tr(),
        scrollController: _scrollController,
        actions: [
          IconButton(
            icon: SvgPicture.asset(
              'assets/icons/ic_settings.svg',
              width: 20,
              height: 20,
            ),
            onPressed: () => context.push('/profile/settings'),
          ),
          Transform.translate(
            offset: const Offset(-8, 0),
            child: IconButton(
              icon: isSigningOut
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : SvgPicture.asset(
                      'assets/icons/ic_logout.svg',
                      width: 20,
                      height: 20,
                    ),
              onPressed: isSigningOut
                  ? null
                  : () => ref.read(authNotifierProvider.notifier).signOut(),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        padding: EdgeInsets.fromLTRB(
          28,
          topPadding + AppSpacing.headerHeight + 32,
          28,
          32,
        ),
        child: SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              profileAsync.when(
                loading: () => const ProfileHeaderSkeleton(),
                error: (_, __) => const SizedBox.shrink(),
                data: (profile) => ProfileHeader(profile: profile, user: user),
              ),
              const SizedBox(height: 48),
              statsAsync.when(
                loading: () => const ProfileKpiSkeleton(),
                error: (_, __) => const ProfileKpi(stats: _zeroStats),
                data: (stats) => ProfileKpi(stats: stats),
              ),
              const SizedBox(height: 32),
              rideDatesAsync.when(
                loading: () => const ProfileStreakBannerSkeleton(),
                error: (_, __) => const SizedBox.shrink(),
                data: (rideDays) => ProfileStreakBanner(rideDays: rideDays),
              ),
              const SizedBox(height: 32),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'profile.calendar.title'.tr(),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.mainContrast,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              rideDatesAsync.when(
                loading: () => const ProfileCalendarSkeleton(),
                error: (_, __) => const ProfileCalendar(),
                data: (rideDays) => ProfileCalendar(rideDays: rideDays),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
