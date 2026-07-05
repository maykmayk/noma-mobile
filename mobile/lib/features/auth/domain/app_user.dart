import 'package:supabase_flutter/supabase_flutter.dart';

class AppUser {
  const AppUser({
    required this.id,
    required this.email,
    required this.username,
    required this.accessToken,
  });

  final String id;
  final String email;
  final String? username;
  final String accessToken;

  factory AppUser.fromSession(Session session) {
    return AppUser(
      id: session.user.id,
      email: session.user.email ?? '',
      username: session.user.userMetadata?['username'] as String?,
      accessToken: session.accessToken,
    );
  }
}
