abstract interface class AuthRepository {
  Future<void> signIn({required String email, required String password});
  Future<void> signUp({
    required String email,
    required String password,
    required String nickname,
    required DateTime birthDate,
  });
  Future<void> signOut();
}
