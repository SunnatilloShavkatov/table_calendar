// Copyright 2019 Aleksander Woźniak
// SPDX-License-Identifier: Apache-2.0

import "package:flutter/widgets.dart";
import "package:flutter_test/flutter_test.dart";
import "package:intl/date_symbol_data_local.dart";
import "package:intl/intl.dart" hide TextDirection;
import "package:table_calendar/src/widgets/cell_content.dart";
import "package:table_calendar/table_calendar.dart";

Widget setupTestWidget(
  DateTime cellDay, {
  CalendarBuilders calendarBuilders = const CalendarBuilders(),
  bool isDisabled = false,
  bool isToday = false,
  bool isWeekend = false,
  bool isOutside = false,
  bool isSelected = false,
  bool isRangeStart = false,
  bool isRangeEnd = false,
  bool isWithinRange = false,
  bool isHoliday = false,
  bool isTodayHighlighted = true,
  String? locale,
}) {
  const CalendarStyle calendarStyle = CalendarStyle();

  return Directionality(
    textDirection: TextDirection.ltr,
    child: CellContent(
      day: cellDay,
      focusedDay: cellDay,
      calendarBuilders: calendarBuilders,
      calendarStyle: calendarStyle,
      isDisabled: isDisabled,
      isToday: isToday,
      isWeekend: isWeekend,
      isOutside: isOutside,
      isSelected: isSelected,
      isRangeStart: isRangeStart,
      isRangeEnd: isRangeEnd,
      isWithinRange: isWithinRange,
      isHoliday: isHoliday,
      isTodayHighlighted: isTodayHighlighted,
      locale: locale,
    ),
  );
}

void main() {
  group("CalendarBuilders flag test:", () {
    testWidgets("selectedBuilder", (WidgetTester tester) async {
      DateTime? builderDay;

      final CalendarBuilders calendarBuilders = CalendarBuilders(
        selectedBuilder: (BuildContext context, DateTime day, DateTime focusedDay) {
          builderDay = day;
          return Text("${day.day}");
        },
      );

      final DateTime cellDay = DateTime.utc(2021, 7, 15);
      expect(builderDay, isNull);

      await tester.pumpWidget(
        setupTestWidget(
          cellDay,
          calendarBuilders: calendarBuilders,
          isSelected: true,
        ),
      );

      expect(builderDay, cellDay);
    });

    testWidgets("rangeStartBuilder", (WidgetTester tester) async {
      DateTime? builderDay;

      final CalendarBuilders calendarBuilders = CalendarBuilders(
        rangeStartBuilder: (BuildContext context, DateTime day, DateTime focusedDay) {
          builderDay = day;
          return Text("${day.day}");
        },
      );

      final DateTime cellDay = DateTime.utc(2021, 7, 15);
      expect(builderDay, isNull);

      await tester.pumpWidget(
        setupTestWidget(
          cellDay,
          calendarBuilders: calendarBuilders,
          isRangeStart: true,
        ),
      );

      expect(builderDay, cellDay);
    });

    testWidgets("rangeEndBuilder", (WidgetTester tester) async {
      DateTime? builderDay;

      final CalendarBuilders calendarBuilders = CalendarBuilders(
        rangeEndBuilder: (BuildContext context, DateTime day, DateTime focusedDay) {
          builderDay = day;
          return Text("${day.day}");
        },
      );

      final DateTime cellDay = DateTime.utc(2021, 7, 15);
      expect(builderDay, isNull);

      await tester.pumpWidget(
        setupTestWidget(
          cellDay,
          calendarBuilders: calendarBuilders,
          isRangeEnd: true,
        ),
      );

      expect(builderDay, cellDay);
    });

    testWidgets("withinRangeBuilder", (WidgetTester tester) async {
      DateTime? builderDay;

      final CalendarBuilders calendarBuilders = CalendarBuilders(
        withinRangeBuilder: (BuildContext context, DateTime day, DateTime focusedDay) {
          builderDay = day;
          return Text("${day.day}");
        },
      );

      final DateTime cellDay = DateTime.utc(2021, 7, 15);
      expect(builderDay, isNull);

      await tester.pumpWidget(
        setupTestWidget(
          cellDay,
          calendarBuilders: calendarBuilders,
          isWithinRange: true,
        ),
      );

      expect(builderDay, cellDay);
    });

    testWidgets("todayBuilder", (WidgetTester tester) async {
      DateTime? builderDay;

      final CalendarBuilders calendarBuilders = CalendarBuilders(
        todayBuilder: (BuildContext context, DateTime day, DateTime focusedDay) {
          builderDay = day;
          return Text("${day.day}");
        },
      );

      final DateTime cellDay = DateTime.utc(2021, 7, 15);
      expect(builderDay, isNull);

      await tester.pumpWidget(
        setupTestWidget(
          cellDay,
          calendarBuilders: calendarBuilders,
          isToday: true,
        ),
      );

      expect(builderDay, cellDay);
    });

    testWidgets("holidayBuilder", (WidgetTester tester) async {
      DateTime? builderDay;

      final CalendarBuilders calendarBuilders = CalendarBuilders(
        holidayBuilder: (BuildContext context, DateTime day, DateTime focusedDay) {
          builderDay = day;
          return Text("${day.day}");
        },
      );

      final DateTime cellDay = DateTime.utc(2021, 7, 15);
      expect(builderDay, isNull);

      await tester.pumpWidget(
        setupTestWidget(
          cellDay,
          calendarBuilders: calendarBuilders,
          isHoliday: true,
        ),
      );

      expect(builderDay, cellDay);
    });

    testWidgets("outsideBuilder", (WidgetTester tester) async {
      DateTime? builderDay;

      final CalendarBuilders calendarBuilders = CalendarBuilders(
        outsideBuilder: (BuildContext context, DateTime day, DateTime focusedDay) {
          builderDay = day;
          return Text("${day.day}");
        },
      );

      final DateTime cellDay = DateTime.utc(2021, 7, 15);
      expect(builderDay, isNull);

      await tester.pumpWidget(
        setupTestWidget(
          cellDay,
          calendarBuilders: calendarBuilders,
          isOutside: true,
        ),
      );

      expect(builderDay, cellDay);
    });

    testWidgets(
      "defaultBuilder gets triggered when no other flags are active",
      (WidgetTester tester) async {
        DateTime? builderDay;

        final CalendarBuilders calendarBuilders = CalendarBuilders(
          defaultBuilder: (BuildContext context, DateTime day, DateTime focusedDay) {
            builderDay = day;
            return Text("${day.day}");
          },
        );

        final DateTime cellDay = DateTime.utc(2021, 7, 15);
        expect(builderDay, isNull);

        await tester.pumpWidget(
          setupTestWidget(
            cellDay,
            calendarBuilders: calendarBuilders,
          ),
        );

        expect(builderDay, cellDay);
      },
    );

    testWidgets(
      "disabledBuilder has higher build order priority than selectedBuilder",
      (WidgetTester tester) async {
        DateTime? builderDay;
        String builderName = "";

        final CalendarBuilders calendarBuilders = CalendarBuilders(
          selectedBuilder: (BuildContext context, DateTime day, DateTime focusedDay) {
            builderName = "selectedBuilder";
            builderDay = day;
            return Text("${day.day}");
          },
          disabledBuilder: (BuildContext context, DateTime day, DateTime focusedDay) {
            builderName = "disabledBuilder";
            builderDay = day;
            return Text("${day.day}");
          },
        );

        final DateTime cellDay = DateTime.utc(2021, 7, 15);
        expect(builderDay, isNull);

        await tester.pumpWidget(
          setupTestWidget(
            cellDay,
            calendarBuilders: calendarBuilders,
            isDisabled: true,
            isSelected: true,
          ),
        );

        expect(builderDay, cellDay);
        expect(builderName, "disabledBuilder");
      },
    );

    testWidgets(
      "prioritizedBuilder has the highest build order priority",
      (WidgetTester tester) async {
        DateTime? builderDay;
        String builderName = "";

        final CalendarBuilders calendarBuilders = CalendarBuilders(
          prioritizedBuilder: (BuildContext context, DateTime day, DateTime focusedDay) {
            builderName = "prioritizedBuilder";
            builderDay = day;
            return Text("${day.day}");
          },
          disabledBuilder: (BuildContext context, DateTime day, DateTime focusedDay) {
            builderName = "disabledBuilder";
            builderDay = day;
            return Text("${day.day}");
          },
        );

        final DateTime cellDay = DateTime.utc(2021, 7, 15);
        expect(builderDay, isNull);

        await tester.pumpWidget(
          setupTestWidget(
            cellDay,
            calendarBuilders: calendarBuilders,
            isDisabled: true,
          ),
        );

        expect(builderDay, cellDay);
        expect(builderName, "prioritizedBuilder");
      },
    );
  });

  group("CalendarBuilders Locale test:", () {
    testWidgets("en locale", (WidgetTester tester) async {
      const String locale = "en";
      await initializeDateFormatting(locale);

      final DateTime cellDay = DateTime.utc(2021, 7, 15);
      await tester.pumpWidget(
        setupTestWidget(
          cellDay,
          locale: locale,
        ),
      );

      final Finder dayFinder = find.text(DateFormat.d(locale).format(cellDay));
      expect(dayFinder, findsOneWidget);
    });

    testWidgets("ar locale", (WidgetTester tester) async {
      const String locale = "ar";
      await initializeDateFormatting(locale);

      final DateTime cellDay = DateTime.utc(2021, 7, 15);
      await tester.pumpWidget(
        setupTestWidget(
          cellDay,
          locale: locale,
        ),
      );

      final Finder dayFinder = find.text(DateFormat.d(locale).format(cellDay));
      expect(dayFinder, findsOneWidget);
    });
  });
}
