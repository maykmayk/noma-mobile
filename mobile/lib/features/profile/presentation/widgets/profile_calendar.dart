import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_theme.dart';

class ProfileCalendar extends StatefulWidget {
  const ProfileCalendar({super.key, this.rideDays = const {}});

  final Set<DateTime> rideDays;

  @override
  State<ProfileCalendar> createState() => _ProfileCalendarState();
}

class _ProfileCalendarState extends State<ProfileCalendar> {
  late DateTime _month;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _month = DateTime(now.year, now.month);
  }

  void _prevMonth() =>
      setState(() => _month = DateTime(_month.year, _month.month - 1));

  void _nextMonth() =>
      setState(() => _month = DateTime(_month.year, _month.month + 1));

  @override
  Widget build(BuildContext context) {
    final locale = context.locale.toString();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      decoration: BoxDecoration(
        color: AppColors.lightBg,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _CalendarHeader(
            month: _month,
            locale: locale,
            onPrev: _prevMonth,
            onNext: _nextMonth,
          ),
          const SizedBox(height: 14),
          _DayNamesRow(locale: locale),
          const SizedBox(height: 4),
          _CalendarGrid(
            month: _month,
            today: DateTime.now(),
            rideDays: widget.rideDays,
          ),
        ],
      ),
    );
  }
}

class _CalendarHeader extends StatelessWidget {
  const _CalendarHeader({
    required this.month,
    required this.locale,
    required this.onPrev,
    required this.onNext,
  });

  final DateTime month;
  final String locale;
  final VoidCallback onPrev;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    final label = DateFormat('MMMM yyyy', locale).format(month);
    return Row(
      children: [
        GestureDetector(
          onTap: onPrev,
          behavior: HitTestBehavior.opaque,
          child: Padding(
            padding: const EdgeInsets.all(4),
            child: Transform.scale(
              scaleX: -1,
              child: SvgPicture.asset(
                'assets/icons/ic_chevron_right.svg',
                width: 20,
                height: 20,
              ),
            ),
          ),
        ),
        Expanded(
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: AppColors.mainContrast,
            ),
          ),
        ),
        GestureDetector(
          onTap: onNext,
          behavior: HitTestBehavior.opaque,
          child: Padding(
            padding: const EdgeInsets.all(4),
            child: SvgPicture.asset(
              'assets/icons/ic_chevron_right.svg',
              width: 20,
              height: 20,
            ),
          ),
        ),
      ],
    );
  }
}

class _DayNamesRow extends StatelessWidget {
  const _DayNamesRow({required this.locale});

  final String locale;

  static final _mondayAnchor = DateTime(2025, 1, 6);

  @override
  Widget build(BuildContext context) {
    final fmt = DateFormat('EEE', locale);
    return Row(
      children: List.generate(7, (i) {
        final raw = fmt.format(_mondayAnchor.add(Duration(days: i)));
        final label = raw.isNotEmpty ? raw.substring(0, 1) : raw;
        return Expanded(
          child: Text(
            label.toUpperCase(),
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
        );
      }),
    );
  }
}

class _CalendarGrid extends StatelessWidget {
  const _CalendarGrid({
    required this.month,
    required this.today,
    required this.rideDays,
  });

  final DateTime month;
  final DateTime today;
  final Set<DateTime> rideDays;

  @override
  Widget build(BuildContext context) {
    final firstDay = DateTime(month.year, month.month, 1);
    final daysInMonth = DateTime(month.year, month.month + 1, 0).day;
    final prevMonthLastDay = DateTime(month.year, month.month, 0).day;

    final leadingCount = firstDay.weekday - 1;
    final totalCurrent = leadingCount + daysInMonth;
    final trailingCount = (7 - totalCurrent % 7) % 7;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        mainAxisExtent: 40,
      ),
      itemCount: totalCurrent + trailingCount,
      itemBuilder: (context, index) {
        if (index < leadingCount) {
          return _DayCell(
            day: prevMonthLastDay - leadingCount + index + 1,
            isCurrentMonth: false,
            isToday: false,
            isRideDay: false,
          );
        }
        final offset = index - leadingCount;
        if (offset < daysInMonth) {
          final day = offset + 1;
          final date = DateTime(month.year, month.month, day);
          final isToday = today.year == month.year &&
              today.month == month.month &&
              today.day == day;
          return _DayCell(
            day: day,
            isCurrentMonth: true,
            isToday: isToday,
            isRideDay: rideDays.contains(date),
          );
        }
        return _DayCell(
          day: offset - daysInMonth + 1,
          isCurrentMonth: false,
          isToday: false,
          isRideDay: false,
        );
      },
    );
  }
}

class _DayCell extends StatelessWidget {
  const _DayCell({
    required this.day,
    required this.isCurrentMonth,
    required this.isToday,
    required this.isRideDay,
  });

  final int day;
  final bool isCurrentMonth;
  final bool isToday;
  final bool isRideDay;

  static const _todayDotColor = Color(0xFF34C759);
  static const _rideGradient = LinearGradient(
    begin: Alignment.topRight,
    end: Alignment.bottomLeft,
    colors: [Color(0xFF5CB270), Color(0xFFF4F269)],
  );

  @override
  Widget build(BuildContext context) {
    if (isRideDay) {
      return Center(
        child: Container(
          width: 28,
          height: 28,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: _rideGradient,
          ),
          child: Center(
            child: Transform.translate(
              offset: const Offset(0, -1),
              child: SvgPicture.asset(
                'assets/icons/ic_bike_ride.svg',
                width: 13,
                height: 13,
              ),
            ),
          ),
        ),
      );
    }

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$day',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: isCurrentMonth
                  ? AppColors.mainContrast
                  : AppColors.textSecondary,
            ),
          ),
          SizedBox(
            height: 6,
            child: isToday
                ? Center(
                    child: Container(
                      width: 4,
                      height: 4,
                      decoration: const BoxDecoration(
                        color: _todayDotColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                  )
                : null,
          ),
        ],
      ),
    );
  }
}
