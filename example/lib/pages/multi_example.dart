// Copyright 2019 Aleksander Woźniak
// SPDX-License-Identifier: Apache-2.0

import "dart:collection";

import "package:flutter/material.dart";
import "package:table_calendar/table_calendar.dart";

import "package:table_calendar_example/utils.dart";

class TableMultiExample extends StatefulWidget {
  const TableMultiExample({super.key});

  @override
  State<TableMultiExample> createState() => _TableMultiExampleState();
}

class _TableMultiExampleState extends State<TableMultiExample> {
  final ValueNotifier<List<Event>> _selectedEvents = ValueNotifier(<Event>[]);

  // Using a `LinkedHashSet` is recommended due to equality comparison override
  final Set<DateTime> _selectedDays = LinkedHashSet<DateTime>(
    equals: isSameDay,
    hashCode: getHashCode,
  );

  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();

  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }

  List<Event> _getEventsForDay(DateTime day) {
    // Implementation example
    return kEvents[day] ?? <Event>[];
  }

  List<Event> _getEventsForDays(Set<DateTime> days) {
    // Implementation example
    // Note that days are in selection order (same applies to events)
    return <Event>[
      for (final DateTime d in days) ..._getEventsForDay(d),
    ];
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _focusedDay = focusedDay;
      // Update values in a Set
      if (_selectedDays.contains(selectedDay)) {
        _selectedDays.remove(selectedDay);
      } else {
        _selectedDays.add(selectedDay);
      }
    });

    _selectedEvents.value = _getEventsForDays(_selectedDays);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        title: const Text("TableCalendar - Multi"),
      ),
      body: Column(
        children: <Widget>[
          TableCalendar<Event>(
            firstDay: kFirstDay,
            lastDay: kLastDay,
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            eventLoader: _getEventsForDay,
            startingDayOfWeek: StartingDayOfWeek.monday,
            selectedDayPredicate: _selectedDays.contains,
            onDaySelected: _onDaySelected,
            onFormatChanged: (CalendarFormat format) {
              if (_calendarFormat != format) {
                setState(() {
                  _calendarFormat = format;
                });
              }
            },
            onPageChanged: (DateTime focusedDay) {
              _focusedDay = focusedDay;
            },
          ),
          ElevatedButton(
            child: const Text("Clear selection"),
            onPressed: () {
              setState(() {
                _selectedDays.clear();
                _selectedEvents.value = <Event>[];
              });
            },
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ValueListenableBuilder<List<Event>>(
              valueListenable: _selectedEvents,
              builder: (BuildContext context, List<Event> value, _) => ListView.builder(
                  itemCount: value.length,
                  itemBuilder: (BuildContext context, int index) => Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        onTap: () => print("${value[index]}"),
                        title: Text("${value[index]}"),
                      ),
                    ),
                ),
            ),
          ),
        ],
      ),
    );
}
