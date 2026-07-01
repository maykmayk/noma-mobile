class UserProfile {
  const UserProfile({
    required this.id,
    required this.avatarNumber,
    this.username,
    this.displayName,
    this.birthDate,
  });

  final String id;
  final String? username;
  final String? displayName;
  final int avatarNumber;
  final DateTime? birthDate;

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] as String,
      username: json['username'] as String?,
      displayName: json['display_name'] as String?,
      avatarNumber: (json['avatar_number'] as int?) ?? 1,
      birthDate: json['birth_date'] != null
          ? DateTime.parse(json['birth_date'] as String)
          : null,
    );
  }
}
