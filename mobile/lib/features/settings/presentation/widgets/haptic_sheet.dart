import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/widgets/app_bottom_sheet/app_bottom_sheet.dart';
import '../settings_providers.dart';
import '_toggle_sheet_content.dart';

void showHapticSheet(BuildContext context) {
  showAppBottomSheet(
    context: context,
    title: 'settings.haptic_sheet.title'.tr(),
    child: Consumer(
      builder: (context, ref, _) {
        final state = ref.watch(hapticEnabledProvider);
        return state.when(
          loading: () => const SizedBox(height: 120),
          error: (_, _) => const SizedBox(height: 120),
          data: (enabled) => ToggleSheetContent(
            label: 'settings.haptic_sheet.label'.tr(),
            description: 'settings.haptic_sheet.description'.tr(),
            value: enabled,
            onSave: (v) => ref.read(hapticEnabledProvider.notifier).set(v),
          ),
        );
      },
    ),
  );
}
