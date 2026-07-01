import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../domain/auth_repository.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return SupabaseAuthRepository(Supabase.instance.client);
});

class SupabaseAuthRepository implements AuthRepository {
  const SupabaseAuthRepository(this._client);

  final SupabaseClient _client;

  @override
  Future<void> signIn({
    required String emailOrUsername,
    required String password,
  }) async {
    final email = emailOrUsername.contains('@')
        ? emailOrUsername
        : await _resolveUsernameToEmail(emailOrUsername);

    await _client.auth.signInWithPassword(email: email, password: password);
  }

  Future<String> _resolveUsernameToEmail(String username) async {
    final result = await _client.rpc(
      'get_email_by_username',
      params: {'p_username': username},
    );
    if (result == null) {
      // Same message Supabase uses — avoids revealing whether the username exists.
      throw const AuthException('Invalid login credentials');
    }
    return result as String;
  }

  @override
  Future<void> signUp({
    required String email,
    required String password,
    required String nickname,
    required DateTime birthDate,
  }) async {
    await _client.auth.signUp(
      email: email,
      password: password,
      data: {
        'nickname': nickname,
        'birth_date':
            '${birthDate.year}-${birthDate.month.toString().padLeft(2, '0')}-${birthDate.day.toString().padLeft(2, '0')}',
      },
    );
  }

  @override
  Future<void> signOut() async {
    await _client.auth.signOut();
  }
}
