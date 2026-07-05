import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/app_bottom_sheet/app_bottom_sheet.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_radio_button.dart';

class _Language {
  const _Language({
    required this.code,
    required this.name,
    required this.flagAsset,
  });

  final String code;
  final String name;
  final String flagAsset;

  Locale get locale => Locale(code);
}

const _languages = [
  _Language(code: 'it', name: 'Italiano', flagAsset: 'assets/flags/flag_it.svg'),
  _Language(code: 'en', name: 'English', flagAsset: 'assets/flags/flag_en.svg'),
];

void showLanguageSheet(BuildContext context) {
  showAppBottomSheet(
    context: context,
    title: 'settings.language_sheet.title'.tr(),
    child: const _LanguageSheetContent(),
  );
}

class _LanguageSheetContent extends StatefulWidget {
  const _LanguageSheetContent();

  @override
  State<_LanguageSheetContent> createState() => _LanguageSheetContentState();
}

class _LanguageSheetContentState extends State<_LanguageSheetContent> {
  late String _selected;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _selected = context.locale.languageCode;
      _initialized = true;
    }
  }

  bool get _changed => _selected != context.locale.languageCode;

  void _apply() {
    context.setLocale(Locale(_selected));
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (int i = 0; i < _languages.length; i++) ...[
          _LanguageRow(
            language: _languages[i],
            selected: _selected == _languages[i].code,
            onTap: () => setState(() => _selected = _languages[i].code),
          ),
          if (i < _languages.length - 1)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Divider(height: 0, thickness: 1, color: AppColors.borderSecondary),
            ),
        ],
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
          child: AppButton(
            label: 'settings.language_sheet.change_button'.tr(),
            onPressed: _changed ? _apply : null,
          ),
        ),
      ],
    );
  }
}

class _LanguageRow extends StatelessWidget {
  const _LanguageRow({
    required this.language,
    required this.selected,
    required this.onTap,
  });

  final _Language language;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Row(
          children: [
            ClipOval(
              child: SvgPicture.asset(
                language.flagAsset,
                width: 24,
                height: 24,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                language.name,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppColors.mainContrast,
                ),
              ),
            ),
            AppRadioButton(selected: selected, onTap: onTap),
          ],
        ),
      ),
    );
  }
}
