import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../auth/presentation/auth_notifier.dart';
import '../data/supabase_profile_repository.dart';
import '../domain/profile_stats.dart';
import '../domain/user_profile.dart';

// Fetches profile from DB. Re-fetches whenever auth state changes (login/logout).
final currentProfileProvider = FutureProvider<UserProfile?>((ref) async {
  final user = ref.watch(currentUserProvider);
  if (user == null) return null;
  return ref.read(profileRepositoryProvider).fetchProfile(user.id);
});

// Fetches ride count and total km from the rides table.
final profileStatsProvider = FutureProvider<ProfileStats>((ref) async {
  final user = ref.watch(currentUserProvider);
  if (user == null) return const ProfileStats(ridesCount: 0, kmTravelled: 0);

  final data = await Supabase.instance.client
      .from('rides')
      .select('distance_km')
      .eq('user_id', user.id);

  final count = data.length;
  final km = data.fold<double>(
    0,
    (sum, r) => sum + ((r['distance_km'] as num?) ?? 0),
  );

  return ProfileStats(ridesCount: count, kmTravelled: km);
});
