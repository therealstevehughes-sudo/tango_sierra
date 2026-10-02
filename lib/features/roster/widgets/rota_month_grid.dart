import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../app/theme/app_colors.dart';

/// Shared month-grid chrome for the rota calendar (2026-10-02) — used by
/// both the staff-facing RotaClaimScreen and the leadership-facing
/// RotaMonthScreen, since both need the exact same "7 columns, Monday
/// first, leading/trailing blanks" skeleton. Only the day-cell content
/// and the tap action differ between the two, so those are the two
/// injection points here; everything else (header, weekday row, grid
/// math) lives in one place.
class RotaMonthGrid extends StatelessWidget {
  const RotaMonthGrid({
    super.key,
    required this.monthStart,
    required this.onChangeMonth,
    required this.onDayTap,
    required this.dayCellBuilder,
    this.isSelected,
  });

  final DateTime monthStart;
  final ValueChanged<int> onChangeMonth;
  final ValueChanged<DateTime> onDayTap;
  final Widget Function(BuildContext context, DateTime day) dayCellBuilder;
  final bool Function(DateTime day)? isSelected;

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).toString();
    final daysInMonth = DateTime(monthStart.year, monthStart.month + 1, 0).day;
    final leadingBlanks = monthStart.weekday - 1;
    final totalCells = leadingBlanks + daysInMonth;
    final trailingBlanks = (7 - (totalCells % 7)) % 7;
    final weekStart = monthStart.subtract(Duration(days: leadingBlanks));

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left),
                onPressed: () => onChangeMonth(-1),
              ),
              Expanded(
                child: Text(
                  DateFormat.yMMMM(locale).format(monthStart),
                  style: Theme.of(context).textTheme.titleMedium,
                  textAlign: TextAlign.center,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right),
                onPressed: () => onChangeMonth(1),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children: [
              for (int i = 0; i < 7; i++)
                Expanded(
                  child: Text(
                    DateFormat.E(
                      locale,
                    ).format(weekStart.add(Duration(days: i))),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: AppColors.mutedLight,
                      fontSize: 12,
                    ),
                  ),
                ),
            ],
          ),
        ),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.all(8),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              childAspectRatio: 0.78,
            ),
            itemCount: leadingBlanks + daysInMonth + trailingBlanks,
            itemBuilder: (context, index) {
              if (index < leadingBlanks ||
                  index >= leadingBlanks + daysInMonth) {
                return const SizedBox.shrink();
              }
              final dayNum = index - leadingBlanks + 1;
              final day = DateTime(monthStart.year, monthStart.month, dayNum);
              final selected = isSelected?.call(day) ?? false;
              final isToday = _isSameDay(day, DateTime.now());
              return InkWell(
                onTap: () => onDayTap(day),
                borderRadius: BorderRadius.circular(6),
                child: Container(
                  margin: const EdgeInsets.all(2),
                  padding: const EdgeInsets.symmetric(
                    vertical: 4,
                    horizontal: 2,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: selected ? AppColors.teal : AppColors.line,
                      width: selected ? 2 : 1,
                    ),
                    borderRadius: BorderRadius.circular(6),
                    color: selected ? AppColors.tealTint : null,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        '$dayNum',
                        style: TextStyle(
                          fontWeight: isToday
                              ? FontWeight.bold
                              : FontWeight.normal,
                          color: isToday ? AppColors.teal : null,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Expanded(child: dayCellBuilder(context, day)),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  static bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;
}

/// A single small coloured dot, used for per-shift status in both the
/// staff and leadership month cells.
class RotaStatusDot extends StatelessWidget {
  const RotaStatusDot({super.key, required this.color, this.size = 7});

  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      margin: const EdgeInsets.symmetric(horizontal: 1, vertical: 1),
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}
