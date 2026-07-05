import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../core/theme/app_theme.dart';

class PageHeader extends StatelessWidget implements PreferredSizeWidget {
  const PageHeader({
    super.key,
    required this.title,
    this.showBack = false,
    this.centerTitle = false,
    this.blurBackground = false,
    this.actions = const [],
  });

  final String title;
  final bool showBack;
  final bool centerTitle;
  final bool blurBackground;
  final List<Widget> actions;

  @override
  Size get preferredSize => const Size.fromHeight(AppSpacing.headerHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: showBack
          ? IconButton(
              icon: SvgPicture.asset(
                'assets/icons/ic_back.svg',
                width: 24,
                height: 24,
              ),
              onPressed: () => Navigator.of(context).maybePop(),
            )
          : null,
      automaticallyImplyLeading: false,
      titleSpacing: showBack ? 0 : null,
      centerTitle: centerTitle,
      backgroundColor: blurBackground ? Colors.transparent : null,
      elevation: blurBackground ? 0 : null,
      surfaceTintColor: blurBackground ? Colors.transparent : null,
      flexibleSpace: blurBackground ? const _BlurBackground() : null,
      title: Text(title),
      actions: actions,
    );
  }
}

class _BlurBackground extends StatelessWidget {
  const _BlurBackground();

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (rect) => const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Colors.white, Colors.transparent],
        stops: [0.55, 1.0],
      ).createShader(rect),
      blendMode: BlendMode.dstIn,
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
          child: Container(
            color: Colors.white.withValues(alpha: 0.82),
          ),
        ),
      ),
    );
  }
}
