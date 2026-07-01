/// Returns the asset path for avatar [number] (1–12).
String avatarAssetPath(int number) {
  final n = number.clamp(1, 12);
  return 'assets/avatars/Avatar_${n.toString().padLeft(2, '0')}.png';
}
