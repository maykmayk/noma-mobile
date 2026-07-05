import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../shared/widgets/collapsing_page_scaffold.dart';
import '../../../shared/widgets/settings_section.dart';
import 'widgets/haptic_sheet.dart';
import 'widgets/language_sheet.dart';
import 'widgets/voice_sheet.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CollapsingPageScaffold(
      title: 'settings.title'.tr(),
      slivers: [
        SliverPadding(
          padding: CollapsingPageScaffold.bodyPadding,
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              SettingsSection(
                label: 'settings.section_main'.tr(),
                items: [
                  SettingsItem(
                    icon: 'assets/icons/ic_account.svg',
                    title: 'settings.account'.tr(),
                  ),
                  SettingsItem(
                    icon: 'assets/icons/ic_app_icon.svg',
                    title: 'settings.app_icon'.tr(),
                  ),
                  SettingsItem(
                    icon: 'assets/icons/ic_language.svg',
                    title: 'settings.language'.tr(),
                    onTap: () => showLanguageSheet(context),
                  ),
                  SettingsItem(
                    icon: 'assets/icons/ic_voice.svg',
                    title: 'settings.voice'.tr(),
                    onTap: () => showVoiceSheet(context),
                  ),
                  SettingsItem(
                    icon: 'assets/icons/ic_haptic.svg',
                    title: 'settings.haptic_feedback'.tr(),
                    isLast: true,
                    onTap: () => showHapticSheet(context),
                  ),
                ],
              ),
              const SizedBox(height: 28),
              SettingsSection(
                label: 'settings.section_help'.tr(),
                items: [
                  SettingsItem(
                    icon: 'assets/icons/ic_privacy.svg',
                    title: 'settings.privacy_policy'.tr(),
                  ),
                  SettingsItem(
                    icon: 'assets/icons/ic_feedback.svg',
                    title: 'settings.feedback'.tr(),
                    isLast: true,
                  ),
                ],
              ),
            ]),
          ),
        ),
      ],
    );
  }
}
