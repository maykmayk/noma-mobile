import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../core/theme/app_theme.dart';
import 'app_bar_blur_background.dart';

class PageHeader extends StatelessWidget implements PreferredSizeWidget {
  const PageHeader({
    super.key,
    required this.title,
    this.showBack = false,
    this.centerTitle = false,
    this.scrollController,
    this.actions = const [],
  });

  final String title;
  final bool showBack;
  final bool centerTitle;

  /// When provided, the blur fades in as the user scrolls past [_blurRange] px.
  /// Requires [Scaffold.extendBodyBehindAppBar] = true on the host screen.
  final ScrollController? scrollController;

  final List<Widget> actions;

  static const double _blurRange = 80.0;

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
      backgroundColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
      forceMaterialTransparency: true,
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      flexibleSpace: scrollController != null
          ? _ScrollAwareBlur(
              scrollController: scrollController!,
              range: _blurRange,
            )
          : null,
      title: Text(title),
      actions: actions,
    );
  }
}

class _ScrollAwareBlur extends StatefulWidget {
  const _ScrollAwareBlur({
    required this.scrollController,
    required this.range,
  });

  final ScrollController scrollController;
  final double range;

  @override
  State<_ScrollAwareBlur> createState() => _ScrollAwareBlurState();
}

class _ScrollAwareBlurState extends State<_ScrollAwareBlur> {
  double _progress = 0;

  @override
  void initState() {
    super.initState();
    widget.scrollController.addListener(_onScroll);
  }

  @override
  void didUpdateWidget(_ScrollAwareBlur old) {
    super.didUpdateWidget(old);
    if (old.scrollController != widget.scrollController) {
      old.scrollController.removeListener(_onScroll);
      widget.scrollController.addListener(_onScroll);
    }
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_onScroll);
    super.dispose();
  }

  void _onScroll() {
    final raw = (widget.scrollController.offset / widget.range).clamp(0.0, 1.0);
    final p = Curves.easeInOut.transform(raw);
    if ((p - _progress).abs() > 0.005) setState(() => _progress = p);
  }

  @override
  Widget build(BuildContext context) {
    return AppBarBlurBackground(progress: _progress);
  }
}
