import 'dart:ui';
import 'package:flutter/material.dart';

/// Blurred frosted-glass background for pinned app bars.
///
/// [progress] ∈ [0, 1]: 0 = fully transparent, 1 = fully opaque blur.
/// A [ShaderMask] fades the bottom edge so the blur dissolves into content.
class AppBarBlurBackground extends StatelessWidget {
  const AppBarBlurBackground({super.key, required this.progress});

  final double progress;

  @override
  Widget build(BuildContext context) {
    if (progress == 0) return const SizedBox.shrink();
    return ShaderMask(
      shaderCallback: (rect) => LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.white.withValues(alpha: progress),
          Colors.transparent,
        ],
        stops: const [0.55, 1.0],
      ).createShader(rect),
      blendMode: BlendMode.dstIn,
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 24 * progress, sigmaY: 24 * progress),
          child: Container(
            color: Colors.white.withValues(alpha: 0.82 * progress),
          ),
        ),
      ),
    );
  }
}
