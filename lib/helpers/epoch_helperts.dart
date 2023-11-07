// ignore: unused_import
import 'package:intl/intl.dart';

// Gets the current epoch number
int getCurrentEpoch() {
  return countWednesdaysBetweenDates(
      DateTime.parse("2022-04-13 12:00:00Z"),
      DateTime.utc(
          DateTime.now().year, DateTime.now().month, DateTime.now().day));
}

// Gets the start and end epoch date for a given date
(DateTime, DateTime) getEpochDates(DateTime dateToCheck) {
  late DateTime startDate;
  late DateTime endDate;
  //Find start day
  if (dateToCheck.toUtc().weekday == 3) {
    if (dateToCheck.toUtc().hour < 12) {
      startDate = dateToCheck.toUtc().subtract(const Duration(days: 7));
      endDate = dateToCheck.toUtc();
    } else {
      startDate = dateToCheck.toUtc();
      endDate = dateToCheck.toUtc().add(const Duration(days: 7));
    }
  } else if (dateToCheck.toUtc().weekday < 3) {
    startDate = dateToCheck
        .toUtc()
        .subtract(Duration(days: dateToCheck.toUtc().weekday + 4));
    endDate = dateToCheck
        .toUtc()
        .add(Duration(days: 3 - dateToCheck.toUtc().weekday));
  } else {
    startDate = dateToCheck
        .toUtc()
        .subtract(Duration(days: dateToCheck.toUtc().weekday + 3));
    endDate = dateToCheck
        .toUtc()
        .add(Duration(days: 7 - dateToCheck.toUtc().weekday + 3));
  }
  return (
    startDate.copyWith(hour: 12, minute: 0, second: 0, millisecond: 0),
    endDate.copyWith(hour: 11, minute: 59, second: 59, millisecond: 999)
  );
}

// Counts the Wednesdays between two dates
int countWednesdaysBetweenDates(DateTime startDate, DateTime endDate) {
  int wednesdayCount = 0;

  // Define a Duration of one day
  Duration oneDay = const Duration(days: 1);

  // Loop through the date range
  DateTime currentDate = startDate;
  while (
      currentDate.isBefore(endDate) || currentDate.isAtSameMomentAs(endDate)) {
    // Check if the current day is Wednesday (weekday returns 3 for Wednesday)
    if (currentDate.weekday == DateTime.wednesday) {
      wednesdayCount++;
    }
    // Move to the next day
    currentDate = currentDate.add(oneDay);
  }

  return wednesdayCount - 1;
}
