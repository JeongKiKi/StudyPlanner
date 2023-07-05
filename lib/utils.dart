import 'dart:collection';

import 'package:studdyplanner/todo_service.dart';
import 'package:table_calendar/table_calendar.dart';

DateTime createTimeForEvent(DateTime date) {
  DateTime removeTimeDate = DateTime.utc(date.year, date.month, date.day);
  return removeTimeDate;
}
