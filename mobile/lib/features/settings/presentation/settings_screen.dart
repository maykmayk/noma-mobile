import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/collapsing_page_scaffold.dart';
import '../../../shared/widgets/settings_section.dart';

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
                label: 'Settings',
                items: [
                  SettingsItem(icon: 'assets/icons/ic_account.svg', title: 'Account'),
                  SettingsItem(icon: 'assets/icons/ic_app_icon.svg', title: 'App Icon'),
                  SettingsItem(icon: 'assets/icons/ic_language.svg', title: 'Language'),
                  SettingsItem(icon: 'assets/icons/ic_voice.svg', title: 'Voice'),
                  SettingsItem(
                    icon: 'assets/icons/ic_haptic.svg',
                    title: 'Haptic Feedback',
                    isLast: true,
                  ),
                ],
              ),
              const SizedBox(height: 28),
              SettingsSection(
                label: 'Help & Feedback',
                items: [
                  SettingsItem(icon: 'assets/icons/ic_privacy.svg', title: 'Privacy Policy'),
                  SettingsItem(
                    icon: 'assets/icons/ic_feedback.svg',
                    title: 'Feedback',
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
