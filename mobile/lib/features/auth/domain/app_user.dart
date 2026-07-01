import 'package:supabase_flutter/supabase_flutter.dart';

class AppUser {
  const AppUser({
    required this.id,
    required this.email,
    required this.nickname,
    required this.accessToken,
  });

  final String id;
  final String email;
  final String? nickname;
  final String accessToken;

  factory AppUser.fromSession(Session session) {
    return AppUser(
      id: session.user.id,
      email: session.user.email ?? '',
      nickname: session.user.userMetadata?['nickname'] as String?,
      accessToken: session.accessToken,
    );
  }
}
