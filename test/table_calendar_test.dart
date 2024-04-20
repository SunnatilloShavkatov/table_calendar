// Copyright 2019 Aleksander Woźniak
// SPDX-License-Identifier: Apache-2.0

// ignore_for_file: always_specify_types, lines_longer_than_80_chars

import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";
import "package:intl/intl.dart" as intl;
import "package:table_calendar/src/widgets/calendar_header.dart";
import "package:table_calendar/src/widgets/cell_content.dart";
import "package:table_calendar/src/widgets/custom_icon_button.dart";
import "package:table_calendar/table_calendar.dart";

import "common.dart";

final DateTime initialFocusedDay = DateTime.utc(2021, 7, 15);
final DateTime today = initialFocusedDay;
final DateTime firstDay = DateTime.utc(2021, 5, 15);
final DateTime lastDay = DateTime.utc(2021, 9, 18);

Widget setupTestWidget(Widget child) => Directionality(
      textDirection: TextDirection.ltr,
      child: Material(child: child),
    );

Widget createTableCalendar({
  DateTime? focusedDay,
  CalendarFormat calendarFormat = CalendarFormat.month,
  void Function(DateTime)? onPageChanged,
  bool sixWeekMonthsEnforced = false,
}) =>
    setupTestWidget(
      TableCalendar<dynamic>(
        focusedDay: focusedDay ?? initialFocusedDay,
        firstDay: firstDay,
        lastDay: lastDay,
        currentDay: today,
        calendarFormat: calendarFormat,
        onPageChanged: onPageChanged,
        sixWeekMonthsEnforced: sixWeekMonthsEnforced,
      ),
    );

ValueKey<String> cellContentKey(DateTime date) =>
    dateToKey(date, prefix: "CellContent-");

void main() {
  group("TableCalendar correctly displays:", () {
    testWidgets(
      "visible day cells for given focusedDay",
      (WidgetTester tester) async {
        await tester.pumpWidget(createTableCalendar());

        final DateTime firstVisibleDay = DateTime.utc(2021, 6, 27);
        final DateTime lastVisibleDay = DateTime.utc(2021, 7, 31);

        final ValueKey<String> focusedDayKey =
            cellContentKey(initialFocusedDay);
        final ValueKey<String> firstVisibleDayKey =
            cellContentKey(firstVisibleDay);
        final ValueKey<String> lastVisibleDayKey =
            cellContentKey(lastVisibleDay);

        final ValueKey<String> startOOBKey =
            cellContentKey(firstVisibleDay.subtract(const Duration(days: 1)));
        final ValueKey<String> endOOBKey =
            cellContentKey(lastVisibleDay.add(const Duration(days: 1)));

        expect(find.byKey(focusedDayKey), findsOneWidget);
        expect(find.byKey(firstVisibleDayKey), findsOneWidget);
        expect(find.byKey(lastVisibleDayKey), findsOneWidget);

        expect(find.byKey(startOOBKey), findsNothing);
        expect(find.byKey(endOOBKey), findsNothing);
      },
    );

    testWidgets(
      "visible day cells after swipe right when in week format",
      (WidgetTester tester) async {
        DateTime? updatedFocusedDay;

        await tester.pumpWidget(
          createTableCalendar(
            calendarFormat: CalendarFormat.week,
            onPageChanged: (DateTime focusedDay) {
              updatedFocusedDay = focusedDay;
            },
          ),
        );

        await tester.drag(
          find.byType(CellContent).first,
          const Offset(500, 0),
        );
        await tester.pumpAndSettle();

        expect(updatedFocusedDay, isNotNull);

        final DateTime firstVisibleDay = DateTime.utc(2021, 7, 4);
        final DateTime lastVisibleDay = DateTime.utc(2021, 7, 10);

        final ValueKey<String> focusedDayKey =
            cellContentKey(updatedFocusedDay!);
        final ValueKey<String> firstVisibleDayKey =
            cellContentKey(firstVisibleDay);
        final ValueKey<String> lastVisibleDayKey =
            cellContentKey(lastVisibleDay);

        final ValueKey<String> startOOBKey =
            cellContentKey(firstVisibleDay.subtract(const Duration(days: 1)));
        final ValueKey<String> endOOBKey =
            cellContentKey(lastVisibleDay.add(const Duration(days: 1)));

        expect(find.byKey(focusedDayKey), findsOneWidget);
        expect(find.byKey(firstVisibleDayKey), findsOneWidget);
        expect(find.byKey(lastVisibleDayKey), findsOneWidget);

        expect(find.byKey(startOOBKey), findsNothing);
        expect(find.byKey(endOOBKey), findsNothing);
      },
    );

    testWidgets(
      "visible day cells after swipe left when in week format",
      (WidgetTester tester) async {
        DateTime? updatedFocusedDay;

        await tester.pumpWidget(
          createTableCalendar(
            calendarFormat: CalendarFormat.week,
            onPageChanged: (DateTime focusedDay) {
              updatedFocusedDay = focusedDay;
            },
          ),
        );

        await tester.drag(
          find.byType(CellContent).first,
          const Offset(-500, 0),
        );
        await tester.pumpAndSettle();

        expect(updatedFocusedDay, isNotNull);

        final DateTime firstVisibleDay = DateTime.utc(2021, 7, 18);
        final DateTime lastVisibleDay = DateTime.utc(2021, 7, 24);

        final ValueKey<String> focusedDayKey =
            cellContentKey(updatedFocusedDay!);
        final ValueKey<String> firstVisibleDayKey =
            cellContentKey(firstVisibleDay);
        final ValueKey<String> lastVisibleDayKey =
            cellContentKey(lastVisibleDay);

        final ValueKey<String> startOOBKey =
            cellContentKey(firstVisibleDay.subtract(const Duration(days: 1)));
        final ValueKey<String> endOOBKey =
            cellContentKey(lastVisibleDay.add(const Duration(days: 1)));

        expect(find.byKey(focusedDayKey), findsOneWidget);
        expect(find.byKey(firstVisibleDayKey), findsOneWidget);
        expect(find.byKey(lastVisibleDayKey), findsOneWidget);

        expect(find.byKey(startOOBKey), findsNothing);
        expect(find.byKey(endOOBKey), findsNothing);
      },
    );

    testWidgets(
      "visible day cells after swipe right when in two weeks format",
      (WidgetTester tester) async {
        DateTime? updatedFocusedDay;

        await tester.pumpWidget(
          createTableCalendar(
            calendarFormat: CalendarFormat.twoWeeks,
            onPageChanged: (DateTime focusedDay) {
              updatedFocusedDay = focusedDay;
            },
          ),
        );

        await tester.drag(
          find.byType(CellContent).first,
          const Offset(500, 0),
        );
        await tester.pumpAndSettle();

        expect(updatedFocusedDay, isNotNull);

        final DateTime firstVisibleDay = DateTime.utc(2021, 6, 20);
        final DateTime lastVisibleDay = DateTime.utc(2021, 7, 3);

        final ValueKey<String> focusedDayKey =
            cellContentKey(updatedFocusedDay!);
        final ValueKey<String> firstVisibleDayKey =
            cellContentKey(firstVisibleDay);
        final ValueKey<String> lastVisibleDayKey =
            cellContentKey(lastVisibleDay);

        final ValueKey<String> startOOBKey =
            cellContentKey(firstVisibleDay.subtract(const Duration(days: 1)));
        final ValueKey<String> endOOBKey =
            cellContentKey(lastVisibleDay.add(const Duration(days: 1)));

        expect(find.byKey(focusedDayKey), findsOneWidget);
        expect(find.byKey(firstVisibleDayKey), findsOneWidget);
        expect(find.byKey(lastVisibleDayKey), findsOneWidget);

        expect(find.byKey(startOOBKey), findsNothing);
        expect(find.byKey(endOOBKey), findsNothing);
      },
    );

    testWidgets(
      "visible day cells after swipe left when in two weeks format",
      (WidgetTester tester) async {
        DateTime? updatedFocusedDay;

        await tester.pumpWidget(
          createTableCalendar(
            calendarFormat: CalendarFormat.twoWeeks,
            onPageChanged: (DateTime focusedDay) {
              updatedFocusedDay = focusedDay;
            },
          ),
        );

        await tester.drag(
          find.byType(CellContent).first,
          const Offset(-500, 0),
        );
        await tester.pumpAndSettle();

        expect(updatedFocusedDay, isNotNull);

        final DateTime firstVisibleDay = DateTime.utc(2021, 7, 18);
        final DateTime lastVisibleDay = DateTime.utc(2021, 7, 31);

        final ValueKey<String> focusedDayKey =
            cellContentKey(updatedFocusedDay!);
        final ValueKey<String> firstVisibleDayKey =
            cellContentKey(firstVisibleDay);
        final ValueKey<String> lastVisibleDayKey =
            cellContentKey(lastVisibleDay);

        final ValueKey<String> startOOBKey =
            cellContentKey(firstVisibleDay.subtract(const Duration(days: 1)));
        final ValueKey<String> endOOBKey =
            cellContentKey(lastVisibleDay.add(const Duration(days: 1)));

        expect(find.byKey(focusedDayKey), findsOneWidget);
        expect(find.byKey(firstVisibleDayKey), findsOneWidget);
        expect(find.byKey(lastVisibleDayKey), findsOneWidget);

        expect(find.byKey(startOOBKey), findsNothing);
        expect(find.byKey(endOOBKey), findsNothing);
      },
    );

    testWidgets(
      "7 day cells in week format",
      (WidgetTester tester) async {
        await tester.pumpWidget(
          createTableCalendar(
            calendarFormat: CalendarFormat.week,
          ),
        );

        final Iterable<Widget> dayCells =
            tester.widgetList(find.byType(CellContent));
        expect(dayCells.length, 7);
      },
    );

    testWidgets(
      "14 day cells in two weeks format",
      (WidgetTester tester) async {
        await tester.pumpWidget(
          createTableCalendar(
            calendarFormat: CalendarFormat.twoWeeks,
          ),
        );

        final Iterable<Widget> dayCells =
            tester.widgetList(find.byType(CellContent));
        expect(dayCells.length, 14);
      },
    );

    testWidgets(
      "35 day cells in month format for July 2021",
      (WidgetTester tester) async {
        await tester.pumpWidget(
          createTableCalendar(),
        );

        final Iterable<Widget> dayCells =
            tester.widgetList(find.byType(CellContent));
        expect(dayCells.length, 35);
      },
    );

    testWidgets(
      "42 day cells in month format for July 2021, when sixWeekMonthsEnforced is set to true",
      (WidgetTester tester) async {
        await tester.pumpWidget(
          createTableCalendar(
            sixWeekMonthsEnforced: true,
          ),
        );

        final Iterable<Widget> dayCells =
            tester.widgetList(find.byType(CellContent));
        expect(dayCells.length, 42);
      },
    );

    testWidgets(
      "CalendarHeader with updated month and year when focusedDay is changed",
      (WidgetTester tester) async {
        await tester.pumpWidget(createTableCalendar());

        String headerText = intl.DateFormat.yMMMM().format(initialFocusedDay);
        expect(find.byType(CalendarHeader), findsOneWidget);
        expect(find.text(headerText), findsOneWidget);

        final DateTime updatedFocusedDay = DateTime.utc(2021, 8, 4);

        await tester.pumpWidget(
          createTableCalendar(focusedDay: updatedFocusedDay),
        );

        headerText = intl.DateFormat.yMMMM().format(updatedFocusedDay);
        expect(find.byType(CalendarHeader), findsOneWidget);
        expect(find.text(headerText), findsOneWidget);
      },
    );

    testWidgets(
      "CalendarHeader with updated month and year when TableCalendar is swiped left",
      (WidgetTester tester) async {
        DateTime? updatedFocusedDay;

        await tester.pumpWidget(
          createTableCalendar(
            onPageChanged: (DateTime focusedDay) {
              updatedFocusedDay = focusedDay;
            },
          ),
        );

        String headerText = intl.DateFormat.yMMMM().format(initialFocusedDay);
        expect(find.byType(CalendarHeader), findsOneWidget);
        expect(find.text(headerText), findsOneWidget);

        await tester.drag(
          find.byType(CellContent).first,
          const Offset(-500, 0),
        );
        await tester.pumpAndSettle();

        expect(updatedFocusedDay, isNotNull);
        expect(updatedFocusedDay!.month, initialFocusedDay.month + 1);

        headerText = intl.DateFormat.yMMMM().format(updatedFocusedDay!);
        expect(find.byType(CalendarHeader), findsOneWidget);
        expect(find.text(headerText), findsOneWidget);

        updatedFocusedDay = null;

        await tester.drag(
          find.byType(CellContent).first,
          const Offset(-500, 0),
        );
        await tester.pumpAndSettle();

        expect(updatedFocusedDay, isNotNull);
        expect(updatedFocusedDay!.month, initialFocusedDay.month + 2);

        headerText = intl.DateFormat.yMMMM().format(updatedFocusedDay!);
        expect(find.byType(CalendarHeader), findsOneWidget);
        expect(find.text(headerText), findsOneWidget);
      },
    );

    testWidgets(
      "CalendarHeader with updated month and year when TableCalendar is swiped right",
      (WidgetTester tester) async {
        DateTime? updatedFocusedDay;

        await tester.pumpWidget(
          createTableCalendar(
            onPageChanged: (DateTime focusedDay) {
              updatedFocusedDay = focusedDay;
            },
          ),
        );

        String headerText = intl.DateFormat.yMMMM().format(initialFocusedDay);
        expect(find.byType(CalendarHeader), findsOneWidget);
        expect(find.text(headerText), findsOneWidget);

        await tester.drag(
          find.byType(CellContent).first,
          const Offset(500, 0),
        );
        await tester.pumpAndSettle();

        expect(updatedFocusedDay, isNotNull);
        expect(updatedFocusedDay!.month, initialFocusedDay.month - 1);

        headerText = intl.DateFormat.yMMMM().format(updatedFocusedDay!);
        expect(find.byType(CalendarHeader), findsOneWidget);
        expect(find.text(headerText), findsOneWidget);

        updatedFocusedDay = null;

        await tester.drag(
          find.byType(CellContent).first,
          const Offset(500, 0),
        );
        await tester.pumpAndSettle();

        expect(updatedFocusedDay, isNotNull);
        expect(updatedFocusedDay!.month, initialFocusedDay.month - 2);

        headerText = intl.DateFormat.yMMMM().format(updatedFocusedDay!);
        expect(find.byType(CalendarHeader), findsOneWidget);
        expect(find.text(headerText), findsOneWidget);
      },
    );

    testWidgets(
      "3 event markers are visible when 3 events are assigned to a given day",
      (WidgetTester tester) async {
        final DateTime eventDay = DateTime.utc(2021, 7, 20);

        await tester.pumpWidget(
          setupTestWidget(
            TableCalendar(
              focusedDay: initialFocusedDay,
              firstDay: firstDay,
              lastDay: lastDay,
              currentDay: today,
              eventLoader: (DateTime day) {
                if (day.day == eventDay.day && day.month == eventDay.month) {
                  return <String>["Event 1", "Event 2", "Event 3"];
                }

                return [];
              },
            ),
          ),
        );

        final ValueKey<String> eventDayKey = cellContentKey(eventDay);
        final Finder eventDayCellContent = find.byKey(eventDayKey);

        final Finder eventDayStack = find.ancestor(
          of: eventDayCellContent,
          matching: find.byType(Stack),
        );

        final Iterable<Widget> eventMarkers = tester.widgetList(
          find.descendant(
            of: eventDayStack,
            matching: find.byWidgetPredicate(
              (Widget marker) => marker is Container && marker.child == null,
            ),
          ),
        );

        expect(eventMarkers.length, 3);
      },
    );

    testWidgets(
      "currentDay correctly marks given day as today",
      (WidgetTester tester) async {
        await tester.pumpWidget(
          setupTestWidget(
            TableCalendar<dynamic>(
              focusedDay: initialFocusedDay,
              firstDay: firstDay,
              lastDay: lastDay,
              currentDay: today,
            ),
          ),
        );

        final ValueKey<String> currentDayKey = cellContentKey(today);
        final CellContent currentDayCellContent =
            tester.widget(find.byKey(currentDayKey)) as CellContent;

        expect(currentDayCellContent.isToday, true);
      },
    );

    testWidgets(
      "if currentDay is absent, DateTime.now() is marked as today",
      (WidgetTester tester) async {
        final DateTime now = DateTime.now();
        final DateTime firstDay =
            DateTime.utc(now.year, now.month - 3, now.day);
        final DateTime lastDay = DateTime.utc(now.year, now.month + 3, now.day);

        await tester.pumpWidget(
          setupTestWidget(
            TableCalendar<dynamic>(
              focusedDay: now,
              firstDay: firstDay,
              lastDay: lastDay,
            ),
          ),
        );

        final ValueKey<String> currentDayKey = cellContentKey(now);
        final CellContent currentDayCellContent =
            tester.widget(find.byKey(currentDayKey)) as CellContent;

        expect(currentDayCellContent.isToday, true);
      },
    );

    testWidgets(
      "selectedDayPredicate correctly marks given day as selected",
      (WidgetTester tester) async {
        final DateTime selectedDay = DateTime.utc(2021, 7, 20);

        await tester.pumpWidget(
          setupTestWidget(
            TableCalendar<dynamic>(
              focusedDay: initialFocusedDay,
              firstDay: firstDay,
              lastDay: lastDay,
              currentDay: today,
              selectedDayPredicate: (DateTime day) =>
                  isSameDay(day, selectedDay),
            ),
          ),
        );

        final ValueKey<String> selectedDayKey = cellContentKey(selectedDay);
        final CellContent selectedDayCellContent =
            tester.widget(find.byKey(selectedDayKey)) as CellContent;

        expect(selectedDayCellContent.isSelected, true);
      },
    );

    testWidgets(
      "holidayPredicate correctly marks given day as holiday",
      (WidgetTester tester) async {
        final DateTime holiday = DateTime.utc(2021, 7, 20);

        await tester.pumpWidget(
          setupTestWidget(
            TableCalendar<dynamic>(
              focusedDay: initialFocusedDay,
              firstDay: firstDay,
              lastDay: lastDay,
              currentDay: today,
              holidayPredicate: (DateTime day) => isSameDay(day, holiday),
            ),
          ),
        );

        final ValueKey<String> holidayKey = cellContentKey(holiday);
        final CellContent holidayCellContent =
            tester.widget(find.byKey(holidayKey)) as CellContent;

        expect(holidayCellContent.isHoliday, true);
      },
    );
  });

  group("CalendarHeader chevrons test:", () {
    testWidgets(
      "tapping on a left chevron navigates to previous calendar page",
      (WidgetTester tester) async {
        await tester.pumpWidget(createTableCalendar());

        expect(find.text("July 2021"), findsOneWidget);

        final Finder leftChevron = find.widgetWithIcon(
          CustomIconButton,
          Icons.chevron_left,
        );

        await tester.tap(leftChevron);
        await tester.pumpAndSettle();

        expect(find.text("June 2021"), findsOneWidget);
      },
    );

    testWidgets(
      "tapping on a right chevron navigates to next calendar page",
      (WidgetTester tester) async {
        await tester.pumpWidget(createTableCalendar());

        expect(find.text("July 2021"), findsOneWidget);

        final Finder rightChevron = find.widgetWithIcon(
          CustomIconButton,
          Icons.chevron_right,
        );

        await tester.tap(rightChevron);
        await tester.pumpAndSettle();

        expect(find.text("August 2021"), findsOneWidget);
      },
    );
  });

  group("Scrolling boundaries are set up properly:", () {
    testWidgets("starting scroll boundary works correctly",
        (WidgetTester tester) async {
      final DateTime focusedDay = DateTime.utc(2021, 6, 15);

      await tester.pumpWidget(createTableCalendar(focusedDay: focusedDay));

      expect(find.byType(TableCalendar), findsOneWidget);
      expect(find.text("June 2021"), findsOneWidget);

      await tester.drag(find.byType(CellContent).first, const Offset(500, 0));
      await tester.pumpAndSettle();
      expect(find.text("May 2021"), findsOneWidget);

      await tester.drag(find.byType(CellContent).first, const Offset(500, 0));
      await tester.pumpAndSettle();
      expect(find.text("May 2021"), findsOneWidget);
    });

    testWidgets("ending scroll boundary works correctly",
        (WidgetTester tester) async {
      final DateTime focusedDay = DateTime.utc(2021, 8, 15);

      await tester.pumpWidget(createTableCalendar(focusedDay: focusedDay));

      expect(find.byType(TableCalendar), findsOneWidget);
      expect(find.text("August 2021"), findsOneWidget);

      await tester.drag(find.byType(CellContent).first, const Offset(-500, 0));
      await tester.pumpAndSettle();
      expect(find.text("September 2021"), findsOneWidget);

      await tester.drag(find.byType(CellContent).first, const Offset(-500, 0));
      await tester.pumpAndSettle();
      expect(find.text("September 2021"), findsOneWidget);
    });
  });

  group("onFormatChanged callback returns correct values:", () {
    testWidgets("when initial format is month", (WidgetTester tester) async {
      CalendarFormat calendarFormat = CalendarFormat.month;

      await tester.pumpWidget(
        setupTestWidget(
          TableCalendar<dynamic>(
            focusedDay: today,
            firstDay: firstDay,
            lastDay: lastDay,
            currentDay: today,
            calendarFormat: calendarFormat,
            onFormatChanged: (CalendarFormat format) {
              calendarFormat = format;
            },
          ),
        ),
      );

      await tester.drag(find.byType(CellContent).first, const Offset(0, -500));
      await tester.pumpAndSettle();
      expect(calendarFormat, CalendarFormat.twoWeeks);

      await tester.drag(find.byType(CellContent).first, const Offset(0, 500));
      await tester.pumpAndSettle();
      expect(calendarFormat, CalendarFormat.month);
    });

    testWidgets("when initial format is two weeks",
        (WidgetTester tester) async {
      CalendarFormat calendarFormat = CalendarFormat.twoWeeks;

      await tester.pumpWidget(
        setupTestWidget(
          TableCalendar<dynamic>(
            focusedDay: today,
            firstDay: firstDay,
            lastDay: lastDay,
            currentDay: today,
            calendarFormat: calendarFormat,
            onFormatChanged: (CalendarFormat format) {
              calendarFormat = format;
            },
          ),
        ),
      );

      await tester.drag(find.byType(CellContent).first, const Offset(0, -500));
      await tester.pumpAndSettle();
      expect(calendarFormat, CalendarFormat.week);

      await tester.drag(find.byType(CellContent).first, const Offset(0, 500));
      await tester.pumpAndSettle();
      expect(calendarFormat, CalendarFormat.month);
    });

    testWidgets("when initial format is week", (WidgetTester tester) async {
      CalendarFormat calendarFormat = CalendarFormat.week;

      await tester.pumpWidget(
        setupTestWidget(
          TableCalendar<dynamic>(
            focusedDay: today,
            firstDay: firstDay,
            lastDay: lastDay,
            currentDay: today,
            calendarFormat: calendarFormat,
            onFormatChanged: (CalendarFormat format) {
              calendarFormat = format;
            },
          ),
        ),
      );

      await tester.drag(find.byType(CellContent).first, const Offset(0, -500));
      await tester.pumpAndSettle();
      expect(calendarFormat, CalendarFormat.week);

      await tester.drag(find.byType(CellContent).first, const Offset(0, 500));
      await tester.pumpAndSettle();
      expect(calendarFormat, CalendarFormat.twoWeeks);
    });
  });

  group("onDaySelected callback test:", () {
    testWidgets(
      "selects correct day when tapped",
      (WidgetTester tester) async {
        DateTime? selectedDay;

        await tester.pumpWidget(
          setupTestWidget(
            TableCalendar<dynamic>(
              focusedDay: initialFocusedDay,
              firstDay: firstDay,
              lastDay: lastDay,
              currentDay: today,
              onDaySelected: (DateTime selected, DateTime focused) {
                selectedDay = selected;
              },
            ),
          ),
        );

        expect(selectedDay, isNull);

        final DateTime tappedDay = DateTime.utc(2021, 7, 18);
        final ValueKey<String> tappedDayKey = cellContentKey(tappedDay);

        await tester.tap(find.byKey(tappedDayKey));
        await tester.pumpAndSettle();
        expect(selectedDay, tappedDay);
      },
    );

    testWidgets(
      "focuses correct day when tapped",
      (WidgetTester tester) async {
        DateTime? focusedDay;

        await tester.pumpWidget(
          setupTestWidget(
            TableCalendar<dynamic>(
              focusedDay: initialFocusedDay,
              firstDay: firstDay,
              lastDay: lastDay,
              currentDay: today,
              onDaySelected: (DateTime selected, DateTime focused) {
                focusedDay = focused;
              },
            ),
          ),
        );

        expect(focusedDay, isNull);

        final DateTime tappedDay = DateTime.utc(2021, 7, 18);
        final ValueKey<String> tappedDayKey = cellContentKey(tappedDay);

        await tester.tap(find.byKey(tappedDayKey));
        await tester.pumpAndSettle();
        expect(focusedDay, tappedDay);
      },
    );

    testWidgets(
      "properly selects and focuses on outside cell tap - previous month (when in month format)",
      (WidgetTester tester) async {
        DateTime? selectedDay;
        DateTime? focusedDay;

        await tester.pumpWidget(
          setupTestWidget(
            TableCalendar<dynamic>(
              focusedDay: initialFocusedDay,
              firstDay: firstDay,
              lastDay: lastDay,
              currentDay: today,
              onDaySelected: (DateTime selected, DateTime focused) {
                selectedDay = selected;
                focusedDay = focused;
              },
            ),
          ),
        );

        expect(selectedDay, isNull);
        expect(focusedDay, isNull);

        final DateTime tappedDay = DateTime.utc(2021, 6, 30);
        final ValueKey<String> tappedDayKey = cellContentKey(tappedDay);

        final DateTime expectedFocusedDay = DateTime.utc(2021, 7);

        await tester.tap(find.byKey(tappedDayKey));
        await tester.pumpAndSettle();
        expect(selectedDay, tappedDay);
        expect(focusedDay, expectedFocusedDay);
      },
    );

    testWidgets(
      "properly selects and focuses on outside cell tap - next month (when in month format)",
      (WidgetTester tester) async {
        DateTime? selectedDay;
        DateTime? focusedDay;

        await tester.pumpWidget(
          setupTestWidget(
            TableCalendar<dynamic>(
              focusedDay: DateTime.utc(2021, 8, 16),
              firstDay: firstDay,
              lastDay: lastDay,
              currentDay: DateTime.utc(2021, 8, 16),
              onDaySelected: (DateTime selected, DateTime focused) {
                selectedDay = selected;
                focusedDay = focused;
              },
            ),
          ),
        );

        expect(selectedDay, isNull);
        expect(focusedDay, isNull);

        final DateTime tappedDay = DateTime.utc(2021, 9);
        final ValueKey<String> tappedDayKey = cellContentKey(tappedDay);

        final DateTime expectedFocusedDay = DateTime.utc(2021, 8, 31);

        await tester.tap(find.byKey(tappedDayKey));
        await tester.pumpAndSettle();
        expect(selectedDay, tappedDay);
        expect(focusedDay, expectedFocusedDay);
      },
    );
  });

  group("onDayLongPressed callback test:", () {
    testWidgets(
      "selects correct day when long pressed",
      (WidgetTester tester) async {
        DateTime? selectedDay;

        await tester.pumpWidget(
          setupTestWidget(
            TableCalendar<dynamic>(
              focusedDay: initialFocusedDay,
              firstDay: firstDay,
              lastDay: lastDay,
              currentDay: today,
              onDayLongPressed: (DateTime selected, DateTime focused) {
                selectedDay = selected;
              },
            ),
          ),
        );

        expect(selectedDay, isNull);

        final DateTime longPressedDay = DateTime.utc(2021, 7, 18);
        final ValueKey<String> longPressedDayKey =
            cellContentKey(longPressedDay);

        await tester.longPress(find.byKey(longPressedDayKey));
        await tester.pumpAndSettle();
        expect(selectedDay, longPressedDay);
      },
    );

    testWidgets(
      "focuses correct day when long pressed",
      (WidgetTester tester) async {
        DateTime? focusedDay;

        await tester.pumpWidget(
          setupTestWidget(
            TableCalendar<dynamic>(
              focusedDay: initialFocusedDay,
              firstDay: firstDay,
              lastDay: lastDay,
              currentDay: today,
              onDayLongPressed: (DateTime selected, DateTime focused) {
                focusedDay = focused;
              },
            ),
          ),
        );

        expect(focusedDay, isNull);

        final DateTime longPressedDay = DateTime.utc(2021, 7, 18);
        final ValueKey<String> longPressedDayKey =
            cellContentKey(longPressedDay);

        await tester.longPress(find.byKey(longPressedDayKey));
        await tester.pumpAndSettle();
        expect(focusedDay, longPressedDay);
      },
    );

    testWidgets(
      "properly selects and focuses on outside cell long press - previous month (when in month format)",
      (WidgetTester tester) async {
        DateTime? selectedDay;
        DateTime? focusedDay;

        await tester.pumpWidget(
          setupTestWidget(
            TableCalendar<dynamic>(
              focusedDay: initialFocusedDay,
              firstDay: firstDay,
              lastDay: lastDay,
              currentDay: today,
              onDayLongPressed: (DateTime selected, DateTime focused) {
                selectedDay = selected;
                focusedDay = focused;
              },
            ),
          ),
        );

        expect(selectedDay, isNull);
        expect(focusedDay, isNull);

        final DateTime longPressedDay = DateTime.utc(2021, 6, 30);
        final ValueKey<String> longPressedDayKey =
            cellContentKey(longPressedDay);

        final DateTime expectedFocusedDay = DateTime.utc(2021, 7);

        await tester.longPress(find.byKey(longPressedDayKey));
        await tester.pumpAndSettle();
        expect(selectedDay, longPressedDay);
        expect(focusedDay, expectedFocusedDay);
      },
    );

    testWidgets(
      "properly selects and focuses on outside cell long press - next month (when in month format)",
      (WidgetTester tester) async {
        DateTime? selectedDay;
        DateTime? focusedDay;

        await tester.pumpWidget(
          setupTestWidget(
            TableCalendar<dynamic>(
              focusedDay: DateTime.utc(2021, 8, 16),
              firstDay: firstDay,
              lastDay: lastDay,
              currentDay: DateTime.utc(2021, 8, 16),
              onDayLongPressed: (DateTime selected, DateTime focused) {
                selectedDay = selected;
                focusedDay = focused;
              },
            ),
          ),
        );

        expect(selectedDay, isNull);
        expect(focusedDay, isNull);

        final DateTime longPressedDay = DateTime.utc(2021, 9);
        final ValueKey<String> longPressedDayKey =
            cellContentKey(longPressedDay);

        final DateTime expectedFocusedDay = DateTime.utc(2021, 8, 31);

        await tester.longPress(find.byKey(longPressedDayKey));
        await tester.pumpAndSettle();
        expect(selectedDay, longPressedDay);
        expect(focusedDay, expectedFocusedDay);
      },
    );
  });

  group("onRangeSelection callback test:", () {
    testWidgets(
      "proper values are returned when second tapped day is after the first one",
      (WidgetTester tester) async {
        DateTime? rangeStart;
        DateTime? rangeEnd;
        DateTime? focusedDay;

        await tester.pumpWidget(
          setupTestWidget(
            TableCalendar<dynamic>(
              focusedDay: initialFocusedDay,
              firstDay: firstDay,
              lastDay: lastDay,
              currentDay: today,
              rangeSelectionMode: RangeSelectionMode.enforced,
              onRangeSelected:
                  (DateTime? start, DateTime? end, DateTime focused) {
                rangeStart = start;
                rangeEnd = end;
                focusedDay = focused;
              },
            ),
          ),
        );

        expect(rangeStart, isNull);
        expect(rangeEnd, isNull);
        expect(focusedDay, isNull);

        final DateTime firstTappedDay = DateTime.utc(2021, 7, 8);
        final DateTime secondTappedDay = DateTime.utc(2021, 7, 21);

        final ValueKey<String> firstTappedDayKey =
            cellContentKey(firstTappedDay);
        final ValueKey<String> secondTappedDayKey =
            cellContentKey(secondTappedDay);

        final DateTime expectedFocusedDay = secondTappedDay;

        await tester.tap(find.byKey(firstTappedDayKey));
        await tester.pumpAndSettle();
        await tester.tap(find.byKey(secondTappedDayKey));
        await tester.pumpAndSettle();
        expect(rangeStart, firstTappedDay);
        expect(rangeEnd, secondTappedDay);
        expect(focusedDay, expectedFocusedDay);
      },
    );

    testWidgets(
      "proper values are returned when second tapped day is before the first one",
      (WidgetTester tester) async {
        DateTime? rangeStart;
        DateTime? rangeEnd;
        DateTime? focusedDay;

        await tester.pumpWidget(
          setupTestWidget(
            TableCalendar<dynamic>(
              focusedDay: initialFocusedDay,
              firstDay: firstDay,
              lastDay: lastDay,
              currentDay: today,
              rangeSelectionMode: RangeSelectionMode.enforced,
              onRangeSelected:
                  (DateTime? start, DateTime? end, DateTime focused) {
                rangeStart = start;
                rangeEnd = end;
                focusedDay = focused;
              },
            ),
          ),
        );

        expect(rangeStart, isNull);
        expect(rangeEnd, isNull);
        expect(focusedDay, isNull);

        final DateTime firstTappedDay = DateTime.utc(2021, 7, 14);
        final DateTime secondTappedDay = DateTime.utc(2021, 7, 7);

        final ValueKey<String> firstTappedDayKey =
            cellContentKey(firstTappedDay);
        final ValueKey<String> secondTappedDayKey =
            cellContentKey(secondTappedDay);

        final DateTime expectedFocusedDay = secondTappedDay;

        await tester.tap(find.byKey(firstTappedDayKey));
        await tester.pumpAndSettle();
        await tester.tap(find.byKey(secondTappedDayKey));
        await tester.pumpAndSettle();
        expect(rangeStart, secondTappedDay);
        expect(rangeEnd, firstTappedDay);
        expect(focusedDay, expectedFocusedDay);
      },
    );

    testWidgets(
      "long press toggles rangeSelectionMode when onDayLongPress callback is null - initial mode is toggledOff",
      (WidgetTester tester) async {
        DateTime? rangeStart;
        DateTime? rangeEnd;
        DateTime? focusedDay;
        DateTime? selectedDay;

        await tester.pumpWidget(
          setupTestWidget(
            TableCalendar<dynamic>(
              focusedDay: initialFocusedDay,
              firstDay: firstDay,
              lastDay: lastDay,
              currentDay: today,
              onDaySelected: (DateTime selected, DateTime focused) {
                selectedDay = selected;
                focusedDay = focused;
              },
              onRangeSelected:
                  (DateTime? start, DateTime? end, DateTime focused) {
                rangeStart = start;
                rangeEnd = end;
                focusedDay = focused;
              },
            ),
          ),
        );

        expect(rangeStart, isNull);
        expect(rangeEnd, isNull);
        expect(focusedDay, isNull);
        expect(selectedDay, isNull);

        final DateTime firstTappedDay = DateTime.utc(2021, 7, 8);
        final DateTime secondTappedDay = DateTime.utc(2021, 7, 21);

        final ValueKey<String> firstTappedDayKey =
            cellContentKey(firstTappedDay);
        final ValueKey<String> secondTappedDayKey =
            cellContentKey(secondTappedDay);

        final DateTime expectedFocusedDay = secondTappedDay;

        await tester.longPress(find.byKey(firstTappedDayKey));
        await tester.pumpAndSettle();

        await tester.tap(find.byKey(firstTappedDayKey));
        await tester.pumpAndSettle();
        await tester.tap(find.byKey(secondTappedDayKey));
        await tester.pumpAndSettle();
        expect(rangeStart, firstTappedDay);
        expect(rangeEnd, secondTappedDay);
        expect(focusedDay, expectedFocusedDay);
        expect(selectedDay, isNull);
      },
    );

    testWidgets(
      "long press toggles rangeSelectionMode when onDayLongPress callback is null - initial mode is toggledOn",
      (WidgetTester tester) async {
        DateTime? rangeStart;
        DateTime? rangeEnd;
        DateTime? focusedDay;
        DateTime? selectedDay;

        await tester.pumpWidget(
          setupTestWidget(
            TableCalendar<dynamic>(
              focusedDay: initialFocusedDay,
              firstDay: firstDay,
              lastDay: lastDay,
              currentDay: today,
              rangeSelectionMode: RangeSelectionMode.toggledOn,
              onDaySelected: (DateTime selected, DateTime focused) {
                selectedDay = selected;
                focusedDay = focused;
              },
              onRangeSelected:
                  (DateTime? start, DateTime? end, DateTime focused) {
                rangeStart = start;
                rangeEnd = end;
                focusedDay = focused;
              },
            ),
          ),
        );

        expect(rangeStart, isNull);
        expect(rangeEnd, isNull);
        expect(focusedDay, isNull);
        expect(selectedDay, isNull);

        final DateTime firstTappedDay = DateTime.utc(2021, 7, 8);
        final DateTime secondTappedDay = DateTime.utc(2021, 7, 21);

        final ValueKey<String> firstTappedDayKey =
            cellContentKey(firstTappedDay);
        final ValueKey<String> secondTappedDayKey =
            cellContentKey(secondTappedDay);

        final DateTime expectedFocusedDay = secondTappedDay;

        await tester.longPress(find.byKey(firstTappedDayKey));
        await tester.pumpAndSettle();

        await tester.tap(find.byKey(firstTappedDayKey));
        await tester.pumpAndSettle();
        await tester.tap(find.byKey(secondTappedDayKey));
        await tester.pumpAndSettle();
        expect(rangeStart, isNull);
        expect(rangeEnd, isNull);
        expect(focusedDay, expectedFocusedDay);
        expect(selectedDay, secondTappedDay);
      },
    );

    testWidgets(
      "rangeSelectionMode.enforced disables onDaySelected callback",
      (WidgetTester tester) async {
        DateTime? rangeStart;
        DateTime? rangeEnd;
        DateTime? focusedDay;
        DateTime? selectedDay;

        await tester.pumpWidget(
          setupTestWidget(
            TableCalendar<dynamic>(
              focusedDay: initialFocusedDay,
              firstDay: firstDay,
              lastDay: lastDay,
              currentDay: today,
              rangeSelectionMode: RangeSelectionMode.enforced,
              onDaySelected: (DateTime selected, DateTime focused) {
                selectedDay = selected;
                focusedDay = focused;
              },
              onRangeSelected:
                  (DateTime? start, DateTime? end, DateTime focused) {
                rangeStart = start;
                rangeEnd = end;
                focusedDay = focused;
              },
            ),
          ),
        );

        expect(rangeStart, isNull);
        expect(rangeEnd, isNull);
        expect(focusedDay, isNull);
        expect(selectedDay, isNull);

        final DateTime firstTappedDay = DateTime.utc(2021, 7, 8);
        final DateTime secondTappedDay = DateTime.utc(2021, 7, 21);

        final ValueKey<String> firstTappedDayKey =
            cellContentKey(firstTappedDay);
        final ValueKey<String> secondTappedDayKey =
            cellContentKey(secondTappedDay);

        final DateTime expectedFocusedDay = secondTappedDay;

        await tester.longPress(find.byKey(firstTappedDayKey));
        await tester.pumpAndSettle();

        await tester.tap(find.byKey(firstTappedDayKey));
        await tester.pumpAndSettle();
        await tester.tap(find.byKey(secondTappedDayKey));
        await tester.pumpAndSettle();
        expect(rangeStart, firstTappedDay);
        expect(rangeEnd, secondTappedDay);
        expect(focusedDay, expectedFocusedDay);
        expect(selectedDay, isNull);
      },
    );

    testWidgets(
      "rangeSelectionMode.disabled enforces onDaySelected callback",
      (WidgetTester tester) async {
        DateTime? rangeStart;
        DateTime? rangeEnd;
        DateTime? focusedDay;
        DateTime? selectedDay;

        await tester.pumpWidget(
          setupTestWidget(
            TableCalendar<dynamic>(
              focusedDay: initialFocusedDay,
              firstDay: firstDay,
              lastDay: lastDay,
              currentDay: today,
              rangeSelectionMode: RangeSelectionMode.disabled,
              onDaySelected: (DateTime selected, DateTime focused) {
                selectedDay = selected;
                focusedDay = focused;
              },
              onRangeSelected:
                  (DateTime? start, DateTime? end, DateTime focused) {
                rangeStart = start;
                rangeEnd = end;
                focusedDay = focused;
              },
            ),
          ),
        );

        expect(rangeStart, isNull);
        expect(rangeEnd, isNull);
        expect(focusedDay, isNull);
        expect(selectedDay, isNull);

        final DateTime firstTappedDay = DateTime.utc(2021, 7, 8);
        final DateTime secondTappedDay = DateTime.utc(2021, 7, 21);

        final ValueKey<String> firstTappedDayKey =
            cellContentKey(firstTappedDay);
        final ValueKey<String> secondTappedDayKey =
            cellContentKey(secondTappedDay);

        final DateTime expectedFocusedDay = secondTappedDay;

        await tester.longPress(find.byKey(firstTappedDayKey));
        await tester.pumpAndSettle();

        await tester.tap(find.byKey(firstTappedDayKey));
        await tester.pumpAndSettle();
        await tester.tap(find.byKey(secondTappedDayKey));
        await tester.pumpAndSettle();
        expect(rangeStart, isNull);
        expect(rangeEnd, isNull);
        expect(focusedDay, expectedFocusedDay);
        expect(selectedDay, secondTappedDay);
      },
    );
  });

  group("Range selection test:", () {
    testWidgets(
      "range selection has correct start and end point",
      (WidgetTester tester) async {
        final DateTime rangeStart = DateTime.utc(2021, 7, 8);
        final DateTime rangeEnd = DateTime.utc(2021, 7, 21);

        await tester.pumpWidget(
          setupTestWidget(
            TableCalendar<dynamic>(
              focusedDay: initialFocusedDay,
              firstDay: firstDay,
              lastDay: lastDay,
              currentDay: today,
              rangeStartDay: rangeStart,
              rangeEndDay: rangeEnd,
            ),
          ),
        );

        final ValueKey<String> rangeStartKey = cellContentKey(rangeStart);
        final CellContent rangeStartCellContent =
            tester.widget(find.byKey(rangeStartKey)) as CellContent;

        expect(rangeStartCellContent.isRangeStart, true);
        expect(rangeStartCellContent.isRangeEnd, false);
        expect(rangeStartCellContent.isWithinRange, true);

        final ValueKey<String> rangeEndKey = cellContentKey(rangeEnd);
        final CellContent rangeEndCellContent =
            tester.widget(find.byKey(rangeEndKey)) as CellContent;

        expect(rangeEndCellContent.isRangeStart, false);
        expect(rangeEndCellContent.isRangeEnd, true);
        expect(rangeEndCellContent.isWithinRange, true);
      },
    );

    testWidgets(
      "days within range selection are marked as inWithinRange",
      (WidgetTester tester) async {
        final DateTime rangeStart = DateTime.utc(2021, 7, 8);
        final DateTime rangeEnd = DateTime.utc(2021, 7, 13);

        await tester.pumpWidget(
          setupTestWidget(
            TableCalendar<dynamic>(
              focusedDay: initialFocusedDay,
              firstDay: firstDay,
              lastDay: lastDay,
              currentDay: today,
              rangeStartDay: rangeStart,
              rangeEndDay: rangeEnd,
            ),
          ),
        );

        final int dayCount = rangeEnd.difference(rangeStart).inDays - 1;
        expect(dayCount, 4);

        for (int i = 1; i <= dayCount; i++) {
          final DateTime testDay = rangeStart.add(Duration(days: i));

          expect(testDay.isAfter(rangeStart), true);
          expect(testDay.isBefore(rangeEnd), true);

          final ValueKey<String> testDayKey = cellContentKey(testDay);
          final CellContent testDayCellContent =
              tester.widget(find.byKey(testDayKey)) as CellContent;

          expect(testDayCellContent.isWithinRange, true);
        }
      },
    );

    testWidgets(
      "days outside range selection are not marked as inWithinRange",
      (WidgetTester tester) async {
        final DateTime rangeStart = DateTime.utc(2021, 7, 8);
        final DateTime rangeEnd = DateTime.utc(2021, 7, 13);

        await tester.pumpWidget(
          setupTestWidget(
            TableCalendar<dynamic>(
              focusedDay: initialFocusedDay,
              firstDay: firstDay,
              lastDay: lastDay,
              currentDay: today,
              rangeStartDay: rangeStart,
              rangeEndDay: rangeEnd,
            ),
          ),
        );

        final DateTime oobStart = rangeStart.subtract(const Duration(days: 1));
        final DateTime oobEnd = rangeEnd.add(const Duration(days: 1));

        final ValueKey<String> oobStartKey = cellContentKey(oobStart);
        final CellContent oobStartCellContent =
            tester.widget(find.byKey(oobStartKey)) as CellContent;

        final ValueKey<String> oobEndKey = cellContentKey(oobEnd);
        final CellContent oobEndCellContent =
            tester.widget(find.byKey(oobEndKey)) as CellContent;

        expect(oobStartCellContent.isWithinRange, false);
        expect(oobEndCellContent.isWithinRange, false);
      },
    );
  });
}
