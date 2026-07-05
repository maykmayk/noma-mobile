import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_switch.dart';

class ToggleSheetContent extends StatefulWidget {
  const ToggleSheetContent({
    super.key,
    required this.label,
    required this.description,
    required this.value,
    required this.onSave,
  });

  final String label;
  final String description;
  final bool value;
  final Future<void> Function(bool) onSave;

  @override
  State<ToggleSheetContent> createState() => _ToggleSheetContentState();
}

class _ToggleSheetContentState extends State<ToggleSheetContent> {
  late bool _current;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _current = widget.value;
  }

  bool get _changed => _current != widget.value;

  Future<void> _save() async {
    setState(() => _saving = true);
    await widget.onSave(_current);
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        GestureDetector(
          onTap: () => setState(() => _current = !_current),
          behavior: HitTestBehavior.opaque,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.label,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.mainContrast,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.description,
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                AppSwitch(
                  value: _current,
                  onChanged: (v) => setState(() => _current = v),
                ),
              ],
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
          child: AppButton(
            label: 'settings.save'.tr(),
            isLoading: _saving,
            onPressed: _changed ? _save : null,
          ),
        ),
      ],
    );
  }
}

