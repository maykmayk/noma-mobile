import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../core/theme/app_theme.dart';
import 'app_bar_blur_background.dart';

/// Full-page scaffold with a collapsing header.
///
/// Header height is fixed. Title animates from large+left to small+center
/// and a gradient blur fades in as the user scrolls the content.
///
/// Usage:
/// ```dart
/// CollapsingPageScaffold(
///   title: 'My Page',
///   slivers: [
///     SliverPadding(
///       padding: CollapsingPageScaffold.bodyPadding,
///       sliver: SliverList(...),
///     ),
///   ],
/// )
/// ```
class CollapsingPageScaffold extends StatefulWidget {
  const CollapsingPageScaffold({
    super.key,
    required this.title,
    required this.slivers,
  });

  final String title;
  final List<Widget> slivers;

  static const EdgeInsets bodyPadding = EdgeInsets.fromLTRB(
    AppSpacing.pageX,
    24,
    AppSpacing.pageX,
    24,
  );

  @override
  State<CollapsingPageScaffold> createState() => _CollapsingPageScaffoldState();
}

class _CollapsingPageScaffoldState extends State<CollapsingPageScaffold> {
  final _scrollController = ScrollController();
  double _progress = 0;

  static const double _animationRange = 150.0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final raw = (_scrollController.offset / _animationRange).clamp(0.0, 1.0);
    final p = Curves.easeInOutCubic.transform(raw);
    if ((p - _progress).abs() > 0.005) setState(() => _progress = p);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.paddingOf(context).top;

    return Scaffold(
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverPersistentHeader(
            pinned: true,
            delegate: _CollapsingHeaderDelegate(
              title: widget.title,
              topPadding: topPadding,
              progress: _progress,
            ),
          ),
          ...widget.slivers,
        ],
      ),
    );
  }
}

class _CollapsingHeaderDelegate extends SliverPersistentHeaderDelegate {
  const _CollapsingHeaderDelegate({
    required this.title,
    required this.topPadding,
    required this.progress,
  });

  final String title;
  final double topPadding;
  final double progress;

  @override
  double get minExtent => topPadding + AppSpacing.headerHeight;

  @override
  double get maxExtent => topPadding + AppSpacing.headerHeight;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    final fontSize = ui.lerpDouble(28, 20, progress)!;

    return Stack(
      fit: StackFit.expand,
      children: [
        if (progress > 0)
          Positioned.fill(child: AppBarBlurBackground(progress: progress)),
        Positioned(
          top: topPadding + (AppSpacing.headerHeight - 48) / 2,
          left: 4,
          width: 48,
          height: 48,
          child: IconButton(
            padding: EdgeInsets.zero,
            icon: SvgPicture.asset(
              'assets/icons/ic_back.svg',
              width: 24,
              height: 24,
            ),
            onPressed: () => Navigator.of(context).maybePop(),
          ),
        ),
        Positioned(
          left: ui.lerpDouble(56, 0, progress),
          right: ui.lerpDouble(AppSpacing.pageX, 0, progress),
          top: ui.lerpDouble(
            topPadding + (AppSpacing.headerHeight - 40) / 2,
            topPadding + (AppSpacing.headerHeight - 30) / 2,
            progress,
          ),
          child: Align(
            alignment: Alignment.lerp(
              Alignment.centerLeft,
              Alignment.center,
              progress,
            )!,
            child: Text(
              title,
              style: TextStyle(
                fontFamily: 'OpenRunde',
                fontSize: fontSize,
                fontWeight: FontWeight.w700,
                color: AppColors.mainContrast,
                letterSpacing: fontSize * -0.02,
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  bool shouldRebuild(_CollapsingHeaderDelegate old) =>
      old.title != title ||
      old.topPadding != topPadding ||
      old.progress != progress;
}

