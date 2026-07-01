import 'package:flutter/material.dart';
import '../utils/avatar_utils.dart';

class UserAvatar extends StatelessWidget {
  const UserAvatar({
    super.key,
    required this.avatarNumber,
    this.size = 96,
  });

  final int avatarNumber;

  /// Diameter in logical pixels.
  final double size;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: size / 2,
      backgroundColor: Colors.transparent,
      backgroundImage: AssetImage(avatarAssetPath(avatarNumber)),
    );
  }
}
