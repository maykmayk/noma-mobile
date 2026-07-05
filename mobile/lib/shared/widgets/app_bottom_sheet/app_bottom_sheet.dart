import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

part '_sheet_handle.dart';

/// Opens [AppBottomSheet] as a modal over a 60%-opacity barrier.
///
/// Dismisses on barrier tap. Content scrolls when it exceeds [maxHeightFraction].
/// [footer] is pinned below the scrollable area (e.g. a CTA button).
Future<T?> showAppBottomSheet<T>({
  required BuildContext context,
  required Widget child,
  String? title,
  Widget? footer,
  double maxHeightFraction = 0.85,
  bool dismissible = true,
}) {
  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: true,
    isDismissible: dismissible,
    enableDrag: dismissible,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black.withValues(alpha: 0.6),
    builder: (_) => AppBottomSheet(
      title: title,
      footer: footer,
      maxHeightFraction: maxHeightFraction,
      child: child,
    ),
  );
}

/// Reusable bottom sheet with handle bar, optional title, scrollable content,
/// and optional pinned [footer] (e.g. a CTA button).
///
/// Use [showAppBottomSheet] to display it.
class AppBottomSheet extends StatelessWidget {
  const AppBottomSheet({
    super.key,
    required this.child,
    this.title,
    this.footer,
    this.maxHeightFraction = 0.85,
  });

  final Widget child;
  final String? title;
  final Widget? footer;
  final double maxHeightFraction;

  @override
  Widget build(BuildContext context) {
    final maxHeight = MediaQuery.sizeOf(context).height * maxHeightFraction;
    final bottomPad = MediaQuery.viewPaddingOf(context).bottom;

    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: maxHeight),
      child: Container(
        decoration: const BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const _SheetHandle(),
            if (title != null) _SheetTitle(title: title!),
            Flexible(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.only(bottom: 8),
                child: child,
              ),
            ),
            if (footer != null)
              Padding(
                padding: EdgeInsets.fromLTRB(24, 12, 24, bottomPad + 24),
                child: footer!,
              ),
            if (footer == null)
              SizedBox(height: bottomPad + 24),
          ],
        ),
      ),
    );
  }
}

class _SheetTitle extends StatelessWidget {
  const _SheetTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w700,
          color: AppColors.mainContrast,
        ),
      ),
    );
  }
}
