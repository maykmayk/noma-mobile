import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../auth/presentation/auth_notifier.dart';
import '../data/supabase_profile_repository.dart';
import '../domain/user_profile.dart';

// Fetches profile from DB. Re-fetches whenever auth state changes (login/logout).
final currentProfileProvider = FutureProvider<UserProfile?>((ref) async {
  final user = ref.watch(currentUserProvider);
  if (user == null) return null;
  return ref.read(profileRepositoryProvider).fetchProfile(user.id);
});
