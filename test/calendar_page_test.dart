// Copyright 2019 Aleksander Woźniak
// SPDX-License-Identifier: Apache-2.0

import "package:flutter/material.dart";
import "package:flutter/widgets.dart";
import "package:flutter_test/flutter_test.dart";
import "package:table_calendar/src/widgets/calendar_page.dart";

Widget setupTestWidget(Widget child) => Directionality(
    textDirection: TextDirection.ltr,
    child: child,
  );

List<DateTime> visibleDays = getDaysInRange(
  DateTime.utc(2021, 6, 27),
  DateTime.utc(2021, 7, 31),
);

List<DateTime> getDaysInRange(DateTime first, DateTime last) {
  final int dayCount = last.difference(first).inDays + 1;
  return List.generate(
    dayCount,
    (int index) => DateTime.utc(first.year, first.month, first.day + index),
  );
}

void main() {
  testWidgets(
    "CalendarPage lays out all the visible days",
    (WidgetTester tester) async {
      await tester.pumpWidget(
        setupTestWidget(
          CalendarPage(
            visibleDays: visibleDays,
            dayBuilder: (BuildContext context, DateTime day) => Text("${day.day}"),
            dowVisible: false,
          ),
        ),
      );

      final int expectedCellCount = visibleDays.length;
      expect(find.byType(Text), findsNWidgets(expectedCellCount));
    },
  );

  testWidgets(
    "CalendarPage lays out 7 DOW labels",
    (WidgetTester tester) async {
      await tester.pumpWidget(
        setupTestWidget(
          CalendarPage(
            visibleDays: visibleDays,
            dayBuilder: (BuildContext context, DateTime day) => Text("${day.day}"),
            dowBuilder: (BuildContext context, DateTime day) => Text("${day.weekday}"),
            dowHeight: 5,
          ),
        ),
      );

      final int expectedCellCount = visibleDays.length;
      const int expectedDowLabels = 7;

      expect(
        find.byType(Text),
        findsNWidgets(expectedCellCount + expectedDowLabels),
      );
    },
  );

  testWidgets(
    "Throw AssertionError when CalendarPage is built with dowVisible set to true, but dowBuilder is absent",
    (WidgetTester tester) async {
      expect(() async {
        await tester.pumpWidget(
          setupTestWidget(
            CalendarPage(
              visibleDays: visibleDays,
              dayBuilder: (BuildContext context, DateTime day) => Text("${day.day}"),
            ),
          ),
        );
      }, throwsAssertionError,);
    },
  );

  testWidgets(
    "Week numbers are not visible by default",
    (WidgetTester tester) async {
      await tester.pumpWidget(
        setupTestWidget(
          CalendarPage(
            visibleDays: visibleDays,
            dayBuilder: (BuildContext context, DateTime day) => Text("${day.day}"),
            dowBuilder: (BuildContext context, DateTime day) => Text("${day.weekday}"),
            dowHeight: 5,
          ),
        ),
      );

      expect(
        find.byType(Column),
        findsNWidgets(0),
      );
    },
  );

  testWidgets(
    "Week numbers are visible",
    (WidgetTester tester) async {
      await tester.pumpWidget(setupTestWidget(
        CalendarPage(
          visibleDays: visibleDays,
          dayBuilder: (BuildContext context, DateTime day) => Text("${day.day}"),
          dowBuilder: (BuildContext context, DateTime day) => Text("${day.weekday}"),
          dowHeight: 5,
          weekNumberVisible: true,
          weekNumberBuilder: (BuildContext context, DateTime day) => Text(day.weekday.toString()),
        ),
      ),);

      expect(
        find.byType(Column),
        findsNWidgets(1),
      );
    },
  );

}
