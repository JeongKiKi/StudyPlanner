DateTime createTimeForEvent(DateTime date) {
  DateTime removeTimeDate = DateTime.utc(date.year, date.month, date.day);
  return removeTimeDate;
}
