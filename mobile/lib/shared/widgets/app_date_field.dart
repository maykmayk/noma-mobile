import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../core/theme/app_theme.dart';

class AppDateField extends StatefulWidget {
  const AppDateField({
    super.key,
    required this.label,
    this.hint,
    required this.value,
    required this.onChanged,
    this.errorText,
    this.firstDate,
    this.lastDate,
  });

  final String label;
  /// If null, falls back to the localized hint ('common.date_hint').
  final String? hint;
  final DateTime? value;
  final ValueChanged<DateTime> onChanged;
  final String? errorText;
  final DateTime? firstDate;
  final DateTime? lastDate;

  @override
  State<AppDateField> createState() => _AppDateFieldState();
}

class _AppDateFieldState extends State<AppDateField> {
  DateTime _tempDate = DateTime(2000);

  String _format(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';

  DateTime get _lastDate {
    if (widget.lastDate != null) return widget.lastDate!;
    final now = DateTime.now();
    return DateTime(now.year - 13, now.month, now.day);
  }

  DateTime get _firstDate => widget.firstDate ?? DateTime(1920);

  void _show(BuildContext context) {
    _tempDate = widget.value ?? DateTime(2000);

    if (Theme.of(context).platform == TargetPlatform.iOS) {
      showCupertinoModalPopup<void>(
        context: context,
        builder: (_) => _IOSPicker(
          initialDate: _tempDate,
          firstDate: _firstDate,
          lastDate: _lastDate,
          onChanged: (d) => _tempDate = d,
          onDone: () {
            Navigator.of(context).pop();
            widget.onChanged(_tempDate);
          },
        ),
      );
    } else {
      showDatePicker(
        context: context,
        initialDate: _tempDate,
        firstDate: _firstDate,
        lastDate: _lastDate,
      ).then((d) {
        if (d != null) widget.onChanged(d);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasError = widget.errorText != null;
    final hint = widget.hint ?? 'common.date_hint'.tr();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 6),
        GestureDetector(
          onTap: () => _show(context),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: AppColors.lightBg,
              borderRadius: BorderRadius.circular(16),
              border: hasError
                  ? Border.all(color: Colors.red, width: 1.5)
                  : null,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    widget.value != null ? _format(widget.value!) : hint,
                    style: TextStyle(
                      fontSize: 16,
                      color: widget.value != null
                          ? AppColors.mainContrast
                          : AppColors.textSecondary,
                    ),
                  ),
                ),
                SvgPicture.asset(
                  'assets/icons/calendar.svg',
                  width: 14,
                  height: 14,
                  colorFilter: const ColorFilter.mode(
                    AppColors.textSecondary,
                    BlendMode.srcIn,
                  ),
                ),
              ],
            ),
          ),
        ),
        if (hasError) ...[
          const SizedBox(height: 6),
          Text(
            widget.errorText!,
            style: const TextStyle(fontSize: 12, color: Colors.red),
          ),
        ],
      ],
    );
  }
}

class _IOSPicker extends StatelessWidget {
  const _IOSPicker({
    required this.initialDate,
    required this.firstDate,
    required this.lastDate,
    required this.onChanged,
    required this.onDone,
  });

  final DateTime initialDate;
  final DateTime firstDate;
  final DateTime lastDate;
  final ValueChanged<DateTime> onChanged;
  final VoidCallback onDone;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              CupertinoButton(
                onPressed: onDone,
                child: Text(
                  'common.date_done'.tr(),
                  style: const TextStyle(
                    color: AppColors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 220,
            child: CupertinoDatePicker(
              mode: CupertinoDatePickerMode.date,
              initialDateTime: initialDate,
              minimumDate: firstDate,
              maximumDate: lastDate,
              onDateTimeChanged: onChanged,
            ),
          ),
          SizedBox(height: MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
  }
}
