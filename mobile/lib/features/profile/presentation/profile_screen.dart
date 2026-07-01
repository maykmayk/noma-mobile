import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '../../../shared/widgets/page_header.dart';
import '../../auth/presentation/auth_notifier.dart';
import '../domain/profile_stats.dart';
import 'profile_providers.dart';
import 'widgets/profile_header.dart';
import 'widgets/profile_header_skeleton.dart';
import 'widgets/profile_kpi.dart';
import 'widgets/profile_kpi_skeleton.dart';

const _zeroStats = ProfileStats(ridesCount: 0, kmTravelled: 0);

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final profileAsync = ref.watch(currentProfileProvider);
    final statsAsync = ref.watch(profileStatsProvider);
    final isSigningOut = ref.watch(authNotifierProvider).isLoading;

    return Scaffold(
      appBar: PageHeader(
        title: 'Profile',
        actions: [
          IconButton(
            icon: SvgPicture.asset(
              'assets/icons/ic_settings.svg',
              width: 20,
              height: 20,
            ),
            onPressed: () => context.push('/profile/settings'),
          ),
          const SizedBox(width: 16),
          IconButton(
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
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 32),
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
            ],
          ),
        ),
      ),
    );
  }
}
