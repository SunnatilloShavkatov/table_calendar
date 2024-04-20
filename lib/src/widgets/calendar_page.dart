// Copyright 2019 Aleksander Woźniak
// SPDX-License-Identifier: Apache-2.0

import "package:flutter/widgets.dart";

class CalendarPage extends StatelessWidget {

  const CalendarPage({
    super.key,
    required this.visibleDays,
    this.dowBuilder,
    required this.dayBuilder,
    this.weekNumberBuilder,
    this.dowDecoration,
    this.rowDecoration,
    this.tableBorder,
    this.tablePadding,
    this.dowVisible = true,
    this.weekNumberVisible = false,
    this.dowHeight,
  })  : assert(!dowVisible || (dowHeight != null && dowBuilder != null), ""),
        assert(!weekNumberVisible || weekNumberBuilder != null, "");
  final Widget Function(BuildContext context, DateTime day)? dowBuilder;
  final Widget Function(BuildContext context, DateTime day) dayBuilder;
  final Widget Function(BuildContext context, DateTime day)? weekNumberBuilder;
  final List<DateTime> visibleDays;
  final Decoration? dowDecoration;
  final Decoration? rowDecoration;
  final TableBorder? tableBorder;
  final EdgeInsets? tablePadding;
  final bool dowVisible;
  final bool weekNumberVisible;
  final double? dowHeight;

  @override
  Widget build(BuildContext context) => Padding(
      padding: tablePadding ?? EdgeInsets.zero,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          if (weekNumberVisible) _buildWeekNumbers(context),
          Expanded(
            child: Table(
              border: tableBorder,
              children: <TableRow>[
                if (dowVisible) _buildDaysOfWeek(context),
                ..._buildCalendarDays(context),
              ],
            ),
          ),
        ],
      ),
    );

  Widget _buildWeekNumbers(BuildContext context) {
    final int rowAmount = visibleDays.length ~/ 7;

    return Column(
      children: <Widget>[
        if (dowVisible) SizedBox(height: dowHeight ?? 0),
        ...List.generate(rowAmount, (int index) => index * 7)
            .map((int index) => Expanded(
                  child: weekNumberBuilder!(context, visibleDays[index]),
                ),)
            ,
      ],
    );
  }

  TableRow _buildDaysOfWeek(BuildContext context) => TableRow(
      decoration: dowDecoration,
      children: List.generate(
        7,
        (int index) => dowBuilder!(context, visibleDays[index]),
      ).toList(),
    );

  List<TableRow> _buildCalendarDays(BuildContext context) {
    final int rowAmount = visibleDays.length ~/ 7;

    return List.generate(rowAmount, (int index) => index * 7)
        .map((int index) => TableRow(
              decoration: rowDecoration,
              children: List.generate(
                7,
                (int id) => dayBuilder(context, visibleDays[index + id]),
              ),
            ),)
        .toList();
  }
}
