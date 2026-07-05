abstract interface class AuthRepository {
  /// [emailOrUsername] accepts either an email address or a username.
  Future<void> signIn({required String emailOrUsername, required String password});
  Future<void> signUp({
    required String email,
    required String password,
    required String username,
    required DateTime birthDate,
  });
  Future<void> signOut();
}
