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

// Fetches ride count and total km from the tracks table.
final profileStatsProvider = FutureProvider<ProfileStats>((ref) async {
  final user = ref.watch(currentUserProvider);
  if (user == null) return const ProfileStats(ridesCount: 0, kmTravelled: 0);

  final data = await Supabase.instance.client
      .from('tracks')
      .select('distance_m')
      .eq('user_id', user.id);

  final count = data.length;
  final km = data.fold<double>(
    0,
    (sum, r) => sum + ((r['distance_m'] as num?) ?? 0) / 1000,
  );

  return ProfileStats(ridesCount: count, kmTravelled: km);
});

// Fetches the distinct calendar dates on which the user completed a ride.
// Uses recorded_at when available, falls back to created_at.
final rideDatesProvider = FutureProvider<Set<DateTime>>((ref) async {
  final user = ref.watch(currentUserProvider);
  if (user == null) return const {};

  final data = await Supabase.instance.client
      .from('tracks')
      .select('recorded_at, created_at')
      .eq('user_id', user.id);

  return data.map<DateTime>((r) {
    final raw = (r['recorded_at'] ?? r['created_at']) as String;
    final dt = DateTime.parse(raw).toLocal();
    return DateTime(dt.year, dt.month, dt.day);
  }).toSet();
});
