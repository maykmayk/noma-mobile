import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/widgets/user_avatar.dart';
import '../../auth/presentation/auth_notifier.dart';
import 'profile_providers.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final profileAsync = ref.watch(currentProfileProvider);
    final isSigningOut = ref.watch(authNotifierProvider).isLoading;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('noma'),
        actions: [
          IconButton(
            icon: isSigningOut
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.logout),
            onPressed: isSigningOut
                ? null
                : () => ref.read(authNotifierProvider.notifier).signOut(),
          ),
        ],
      ),
      body: Center(
        child: profileAsync.when(
          loading: () => const CircularProgressIndicator(),
          error: (e, _) => Text('Errore: $e'),
          data: (profile) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              UserAvatar(
                avatarNumber: profile?.avatarNumber ?? 1,
                size: 96,
              ),
              const SizedBox(height: 16),
              Text(
                profile?.username ?? user?.nickname ?? user?.email ?? '',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                user?.email ?? '',
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
