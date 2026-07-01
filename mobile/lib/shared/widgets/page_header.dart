import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class PageHeader extends StatelessWidget implements PreferredSizeWidget {
  const PageHeader({
    super.key,
    required this.title,
    this.actions = const [],
  });

  final String title;
  final List<Widget> actions;

  @override
  Size get preferredSize => const Size.fromHeight(AppSpacing.headerHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      actions: actions,
    );
  }
}
