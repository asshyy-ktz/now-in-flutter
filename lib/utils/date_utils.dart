import 'package:intl/intl.dart';

class DateUtilsHelper {
  static String getCurrentUtcDateOnly() {
    return DateFormat("yyyy-MM-dd").format(DateTime.now().toUtc());
  }

  static String extractDateOnly(String isoDateString) {
    DateTime dateTime = DateTime.parse(isoDateString);
    return DateFormat("yyyy-MM-dd").format(dateTime);
  }

  /// Returns the current date-time in UTC format (ISO 8601)
  static String getCurrentUtcTime() {
    return DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
        .format(DateTime.now().toUtc());
  }

  /// Formats a DateTime object to a given format
  static String formatDateTime(DateTime dateTime, String format) {
    return DateFormat(format).format(dateTime);
  }

  /// Parses a date string into a DateTime object
  static DateTime parseDateTime(String dateString, String format) {
    return DateFormat(format).parse(dateString);
  }

  /// Converts a DateTime object to UTC format
  static String toUtcString(DateTime dateTime) {
    return DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").format(dateTime.toUtc());
  }

  /// Converts a DateTime object to Local format
  static DateTime toLocalTime(DateTime dateTime) {
    return dateTime.toLocal();
  }

  /// Converts UTC time string to local DateTime object
  static DateTime utcStringToLocal(String utcString) {
    return DateTime.parse(utcString).toLocal();
  }

  /// Returns difference between two dates in days
  static int differenceInDays(DateTime from, DateTime to) {
    return to.difference(from).inDays;
  }

  /// Adds days to a given date
  static DateTime addDays(DateTime date, int days) {
    return date.add(Duration(days: days));
  }

  /// Subtracts days from a given date
  static DateTime subtractDays(DateTime date, int days) {
    return date.subtract(Duration(days: days));
  }

  /// Checks if a year is a leap year
  static bool isLeapYear(int year) {
    return (year % 4 == 0 && year % 100 != 0) || (year % 400 == 0);
  }

  /// Get the start of the day (00:00:00)
  static DateTime startOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  /// Get the end of the day (23:59:59.999)
  static DateTime endOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day, 23, 59, 59, 999);
  }
}
