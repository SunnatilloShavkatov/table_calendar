// Copyright 2019 Aleksander Woźniak
// SPDX-License-Identifier: Apache-2.0

import "package:flutter/material.dart";
import "package:flutter/widgets.dart";
import "package:flutter_test/flutter_test.dart";
import "package:simple_gesture_detector/simple_gesture_detector.dart";
import "package:table_calendar/table_calendar.dart";

import "common.dart";

Widget setupTestWidget(Widget child) => Directionality(
    textDirection: TextDirection.ltr,
    child: child,
  );

void main() {
  group("Correct days are displayed for given focusedDay when:", () {
    testWidgets(
      "in month format, starting day is Sunday",
      (WidgetTester tester) async {
        final DateTime focusedDay = DateTime.utc(2021, 7, 15);

        await tester.pumpWidget(
          setupTestWidget(
            TableCalendarBase(
              firstDay: DateTime.utc(2021, 5, 15),
              lastDay: DateTime.utc(2021, 8, 18),
              focusedDay: focusedDay,
              dayBuilder: (BuildContext context, DateTime day, DateTime focusedDay) => Text(
                  "${day.day}",
                  key: dateToKey(day),
                ),
              rowHeight: 52,
              dowVisible: false,
            ),
          ),
        );

        final DateTime firstVisibleDay = DateTime.utc(2021, 6, 27);
        final DateTime lastVisibleDay = DateTime.utc(2021, 7, 31);

        final ValueKey<String> focusedDayKey = dateToKey(focusedDay);
        final ValueKey<String> firstVisibleDayKey = dateToKey(firstVisibleDay);
        final ValueKey<String> lastVisibleDayKey = dateToKey(lastVisibleDay);

        final ValueKey<String> startOOBKey =
            dateToKey(firstVisibleDay.subtract(const Duration(days: 1)));
        final ValueKey<String> endOOBKey =
            dateToKey(lastVisibleDay.add(const Duration(days: 1)));

        expect(find.byKey(focusedDayKey), findsOneWidget);
        expect(find.byKey(firstVisibleDayKey), findsOneWidget);
        expect(find.byKey(lastVisibleDayKey), findsOneWidget);

        expect(find.byKey(startOOBKey), findsNothing);
        expect(find.byKey(endOOBKey), findsNothing);
      },
    );

    testWidgets(
      "in two weeks format, starting day is Sunday",
      (WidgetTester tester) async {
        final DateTime focusedDay = DateTime.utc(2021, 7, 15);

        await tester.pumpWidget(
          setupTestWidget(
            TableCalendarBase(
              firstDay: DateTime.utc(2021, 5, 15),
              lastDay: DateTime.utc(2021, 8, 18),
              focusedDay: focusedDay,
              dayBuilder: (BuildContext context, DateTime day, DateTime focusedDay) => Text(
                  "${day.day}",
                  key: dateToKey(day),
                ),
              rowHeight: 52,
              dowVisible: false,
              calendarFormat: CalendarFormat.twoWeeks,
            ),
          ),
        );

        final DateTime firstVisibleDay = DateTime.utc(2021, 7, 4);
        final DateTime lastVisibleDay = DateTime.utc(2021, 7, 17);

        final ValueKey<String> focusedDayKey = dateToKey(focusedDay);
        final ValueKey<String> firstVisibleDayKey = dateToKey(firstVisibleDay);
        final ValueKey<String> lastVisibleDayKey = dateToKey(lastVisibleDay);

        final ValueKey<String> startOOBKey =
            dateToKey(firstVisibleDay.subtract(const Duration(days: 1)));
        final ValueKey<String> endOOBKey =
            dateToKey(lastVisibleDay.add(const Duration(days: 1)));

        expect(find.byKey(focusedDayKey), findsOneWidget);
        expect(find.byKey(firstVisibleDayKey), findsOneWidget);
        expect(find.byKey(lastVisibleDayKey), findsOneWidget);

        expect(find.byKey(startOOBKey), findsNothing);
        expect(find.byKey(endOOBKey), findsNothing);
      },
    );

    testWidgets(
      "in week format, starting day is Sunday",
      (WidgetTester tester) async {
        final DateTime focusedDay = DateTime.utc(2021, 7, 15);

        await tester.pumpWidget(
          setupTestWidget(
            TableCalendarBase(
              firstDay: DateTime.utc(2021, 5, 15),
              lastDay: DateTime.utc(2021, 8, 18),
              focusedDay: focusedDay,
              dayBuilder: (BuildContext context, DateTime day, DateTime focusedDay) => Text(
                  "${day.day}",
                  key: dateToKey(day),
                ),
              rowHeight: 52,
              dowVisible: false,
              calendarFormat: CalendarFormat.week,
            ),
          ),
        );

        final DateTime firstVisibleDay = DateTime.utc(2021, 7, 11);
        final DateTime lastVisibleDay = DateTime.utc(2021, 7, 17);

        final ValueKey<String> focusedDayKey = dateToKey(focusedDay);
        final ValueKey<String> firstVisibleDayKey = dateToKey(firstVisibleDay);
        final ValueKey<String> lastVisibleDayKey = dateToKey(lastVisibleDay);

        final ValueKey<String> startOOBKey =
            dateToKey(firstVisibleDay.subtract(const Duration(days: 1)));
        final ValueKey<String> endOOBKey =
            dateToKey(lastVisibleDay.add(const Duration(days: 1)));

        expect(find.byKey(focusedDayKey), findsOneWidget);
        expect(find.byKey(firstVisibleDayKey), findsOneWidget);
        expect(find.byKey(lastVisibleDayKey), findsOneWidget);

        expect(find.byKey(startOOBKey), findsNothing);
        expect(find.byKey(endOOBKey), findsNothing);
      },
    );

    testWidgets(
      "in month format, starting day is Monday",
      (WidgetTester tester) async {
        final DateTime focusedDay = DateTime.utc(2021, 7, 15);

        await tester.pumpWidget(
          setupTestWidget(
            TableCalendarBase(
              firstDay: DateTime.utc(2021, 5, 15),
              lastDay: DateTime.utc(2021, 8, 18),
              focusedDay: focusedDay,
              dayBuilder: (BuildContext context, DateTime day, DateTime focusedDay) => Text(
                  "${day.day}",
                  key: dateToKey(day),
                ),
              rowHeight: 52,
              dowVisible: false,
              startingDayOfWeek: StartingDayOfWeek.monday,
            ),
          ),
        );

        final DateTime firstVisibleDay = DateTime.utc(2021, 6, 28);
        final DateTime lastVisibleDay = DateTime.utc(2021, 8);

        final ValueKey<String> focusedDayKey = dateToKey(focusedDay);
        final ValueKey<String> firstVisibleDayKey = dateToKey(firstVisibleDay);
        final ValueKey<String> lastVisibleDayKey = dateToKey(lastVisibleDay);

        final ValueKey<String> startOOBKey =
            dateToKey(firstVisibleDay.subtract(const Duration(days: 1)));
        final ValueKey<String> endOOBKey =
            dateToKey(lastVisibleDay.add(const Duration(days: 1)));

        expect(find.byKey(focusedDayKey), findsOneWidget);
        expect(find.byKey(firstVisibleDayKey), findsOneWidget);
        expect(find.byKey(lastVisibleDayKey), findsOneWidget);

        expect(find.byKey(startOOBKey), findsNothing);
        expect(find.byKey(endOOBKey), findsNothing);
      },
    );

    testWidgets(
      "in two weeks format, starting day is Monday",
      (WidgetTester tester) async {
        final DateTime focusedDay = DateTime.utc(2021, 7, 15);

        await tester.pumpWidget(
          setupTestWidget(
            TableCalendarBase(
              firstDay: DateTime.utc(2021, 5, 15),
              lastDay: DateTime.utc(2021, 8, 18),
              focusedDay: focusedDay,
              dayBuilder: (BuildContext context, DateTime day, DateTime focusedDay) => Text(
                  "${day.day}",
                  key: dateToKey(day),
                ),
              rowHeight: 52,
              dowVisible: false,
              calendarFormat: CalendarFormat.twoWeeks,
              startingDayOfWeek: StartingDayOfWeek.monday,
            ),
          ),
        );

        final DateTime firstVisibleDay = DateTime.utc(2021, 7, 5);
        final DateTime lastVisibleDay = DateTime.utc(2021, 7, 18);

        final ValueKey<String> focusedDayKey = dateToKey(focusedDay);
        final ValueKey<String> firstVisibleDayKey = dateToKey(firstVisibleDay);
        final ValueKey<String> lastVisibleDayKey = dateToKey(lastVisibleDay);

        final ValueKey<String> startOOBKey =
            dateToKey(firstVisibleDay.subtract(const Duration(days: 1)));
        final ValueKey<String> endOOBKey =
            dateToKey(lastVisibleDay.add(const Duration(days: 1)));

        expect(find.byKey(focusedDayKey), findsOneWidget);
        expect(find.byKey(firstVisibleDayKey), findsOneWidget);
        expect(find.byKey(lastVisibleDayKey), findsOneWidget);

        expect(find.byKey(startOOBKey), findsNothing);
        expect(find.byKey(endOOBKey), findsNothing);
      },
    );

    testWidgets(
      "in week format, starting day is Monday",
      (WidgetTester tester) async {
        final DateTime focusedDay = DateTime.utc(2021, 7, 15);

        await tester.pumpWidget(
          setupTestWidget(
            TableCalendarBase(
              firstDay: DateTime.utc(2021, 5, 15),
              lastDay: DateTime.utc(2021, 8, 18),
              focusedDay: focusedDay,
              dayBuilder: (BuildContext context, DateTime day, DateTime focusedDay) => Text(
                  "${day.day}",
                  key: dateToKey(day),
                ),
              rowHeight: 52,
              dowVisible: false,
              calendarFormat: CalendarFormat.week,
              startingDayOfWeek: StartingDayOfWeek.monday,
            ),
          ),
        );

        final DateTime firstVisibleDay = DateTime.utc(2021, 7, 12);
        final DateTime lastVisibleDay = DateTime.utc(2021, 7, 18);

        final ValueKey<String> focusedDayKey = dateToKey(focusedDay);
        final ValueKey<String> firstVisibleDayKey = dateToKey(firstVisibleDay);
        final ValueKey<String> lastVisibleDayKey = dateToKey(lastVisibleDay);

        final ValueKey<String> startOOBKey =
            dateToKey(firstVisibleDay.subtract(const Duration(days: 1)));
        final ValueKey<String> endOOBKey =
            dateToKey(lastVisibleDay.add(const Duration(days: 1)));

        expect(find.byKey(focusedDayKey), findsOneWidget);
        expect(find.byKey(firstVisibleDayKey), findsOneWidget);
        expect(find.byKey(lastVisibleDayKey), findsOneWidget);

        expect(find.byKey(startOOBKey), findsNothing);
        expect(find.byKey(endOOBKey), findsNothing);
      },
    );
  });

  testWidgets(
    "Callbacks return expected values",
    (WidgetTester tester) async {
      DateTime focusedDay = DateTime.utc(2021, 7, 15);
      final int nextMonth = focusedDay.add(const Duration(days: 31)).month;

      bool calendarCreatedFlag = false;
      SwipeDirection? verticalSwipeDirection;

      await tester.pumpWidget(
        setupTestWidget(
          TableCalendarBase(
            firstDay: DateTime.utc(2021, 5, 15),
            lastDay: DateTime.utc(2021, 8, 18),
            focusedDay: focusedDay,
            dayBuilder: (BuildContext context, DateTime day, DateTime focusedDay) => Text(
                "${day.day}",
                key: dateToKey(day),
              ),
            onCalendarCreated: (PageController pageController) {
              calendarCreatedFlag = true;
            },
            onPageChanged: (DateTime focusedDay2) {
              focusedDay = focusedDay2;
            },
            onVerticalSwipe: (SwipeDirection direction) {
              verticalSwipeDirection = direction;
            },
            rowHeight: 52,
            dowVisible: false,
          ),
        ),
      );

      expect(calendarCreatedFlag, true);

      // Swipe left
      await tester.drag(
        find.byKey(dateToKey(focusedDay)),
        const Offset(-500, 0),
      );
      await tester.pumpAndSettle();
      expect(focusedDay.month, nextMonth);

      // Swipe up
      await tester.drag(
        find.byKey(dateToKey(focusedDay)),
        const Offset(0, -500),
      );
      await tester.pumpAndSettle();
      expect(verticalSwipeDirection, SwipeDirection.up);
    },
  );

  testWidgets(
    "Throw AssertionError when TableCalendarBase is built with dowVisible and dowBuilder, but dowHeight is absent",
    (WidgetTester tester) async {
      expect(() async {
        await tester.pumpWidget(
          setupTestWidget(
            TableCalendarBase(
              firstDay: DateTime.utc(2021, 5, 15),
              lastDay: DateTime.utc(2021, 8, 18),
              focusedDay: DateTime.utc(2021, 7, 15),
              dayBuilder: (BuildContext context, DateTime day, DateTime focusedDay) => Text(
                  "${day.day}",
                  key: dateToKey(day),
                ),
              rowHeight: 52,
              dowBuilder: (BuildContext context, DateTime day) => Text("${day.weekday}"),
            ),
          ),
        );
      }, throwsAssertionError,);
    },
  );
}
