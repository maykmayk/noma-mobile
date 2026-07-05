import 'package:flutter/material.dart';
import '../../../../shared/widgets/user_avatar.dart';
import '../../../auth/domain/app_user.dart';
import '../../domain/user_profile.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({
    super.key,
    required this.profile,
    required this.user,
  });

  final UserProfile? profile;
  final AppUser? user;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        UserAvatar(
          avatarNumber: profile?.avatarNumber ?? 1,
          size: 80,
        ),
        const SizedBox(height: 16),
        Text(
          profile?.username ?? user?.username ?? user?.email ?? '',
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          user?.email ?? '',
          style: const TextStyle(fontSize: 16, color: Colors.grey),
        ),
      ],
    );
  }
}
