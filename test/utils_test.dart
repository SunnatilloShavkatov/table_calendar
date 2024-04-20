// Copyright 2019 Aleksander Woźniak
// SPDX-License-Identifier: Apache-2.0

import "package:flutter_test/flutter_test.dart";
import "package:table_calendar/src/shared/utils.dart";

void main() {
  group("isSameDay() tests:", () {
    test("Same day, different time", () {
      final DateTime dateA = DateTime(2020, 5, 10, 4, 32, 16);
      final DateTime dateB = DateTime(2020, 5, 10, 8, 21, 44);

      expect(isSameDay(dateA, dateB), true);
    });

    test("Different day, same time", () {
      final DateTime dateA = DateTime(2020, 5, 10, 4, 32, 16);
      final DateTime dateB = DateTime(2020, 5, 11, 4, 32, 16);

      expect(isSameDay(dateA, dateB), false);
    });

    test("UTC and local time zone", () {
      final DateTime dateA = DateTime.utc(2020, 5, 10);
      final DateTime dateB = DateTime(2020, 5, 10);

      expect(isSameDay(dateA, dateB), true);
    });
  });

  group("normalizeDate() tests:", () {
    test("Local time zone gets converted to UTC", () {
      final DateTime dateA = DateTime(2020, 5, 10, 4, 32, 16);
      final DateTime dateB = normalizeDate(dateA);

      expect(dateB.isUtc, true);
    });

    test("Date is unchanged", () {
      final DateTime dateA = DateTime(2020, 5, 10, 4, 32, 16);
      final DateTime dateB = normalizeDate(dateA);

      expect(dateB.year, 2020);
      expect(dateB.month, 5);
      expect(dateB.day, 10);
    });

    test("Time gets trimmed", () {
      final DateTime dateA = DateTime(2020, 5, 10, 4, 32, 16);
      final DateTime dateB = normalizeDate(dateA);

      expect(dateB.hour, 0);
      expect(dateB.minute, 0);
      expect(dateB.second, 0);
      expect(dateB.millisecond, 0);
      expect(dateB.microsecond, 0);
    });
  });

  group("getWeekdayNumber() tests:", () {
    test("Monday returns number 1", () {
      expect(getWeekdayNumber(StartingDayOfWeek.monday), 1);
    });

    test("Sunday returns number 7", () {
      expect(getWeekdayNumber(StartingDayOfWeek.sunday), 7);
    });
  });
}
