import 'package:flutter/foundation.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

import '../services/http_calls.dart';

class Dates {
  Dates._();
  static const String pGetTime12 = 'hh:mm:ss a';
  static const String pGetTime24 = 'HH:mm:ss';
  static const String pGetTime24WithOutSec = 'HH:mm';
  static const String pGetTime12WithOutSec = 'hh:mm a';
  static const String pGetTimeWithSec = 'hh:mm:ss a';
  static const String pGetDateTime = 'dd-MM-yyyy HH:mm';
  static const String pGetShortDate = 'dd-MM-yyyy';
  static const String pGetLongDate = 'dd-MMM-yyyy';
  static const String pGetDateFormat = 'yyyy-MM-dd';
  static const String pGetDate = 'dd-MMM-yyyy';
  static const String pGetDay = 'dd';
  static const String pGetMonth = 'MMM';
  static const String pGetDateFullMonth = 'dd-MMMM-yyyy';
  static const String pGetMonthAndDate = 'MMM dd';
  static const String pGetMonthDayAndTime = 'MMM dd, hh:mm a';
  static const String pGetMonthDayAndTimeForDifference = 'dd-MM-yyyy, hh:mm a';

  static Future<void> initializeDateFormat({String? localization}) async {
    await initializeDateFormatting(
        localization ?? HttpCalls.localization ?? 'en', null);
  }

  static DateFormat pDateFormatter({String? localization}) {
    var formatter = DateFormat(
        Dates.pGetDate, localization ?? HttpCalls.localization ?? 'en');
    return formatter;
  }

  static DateFormat pDateTimeFormatter({String? localization}) {
    return DateFormat(
        pGetDateTime, localization ?? HttpCalls.localization ?? 'en');
  }

  static String pDateToString(DateTime? dateTime,
      {String? defaultValue, String? localization}) {
    try {
      if (dateTime == null) {
        return defaultValue ?? '';
      }
      String formatted =
          pDateFormatter(localization: localization).format(dateTime);
      return formatted;
    } catch (e) {
      return '00-00-0000';
    }
  }

  static String pDateTimeToString(DateTime? dateTime,
      {String? defaultValue, String? localization}) {
    try {
      if (dateTime == null) {
        return defaultValue ?? '';
      }
      String formatted =
          pDateTimeFormatter(localization: localization).format(dateTime);
      return formatted;
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      return '00-00-0000';
    }
  }

  static String pGetDateTimeCustomFormat(DateTime? dateTime, String format,
      {String? defaultValue, String? localization}) {
    try {
      if (dateTime == null) {
        return defaultValue ?? '';
      }
      String formatted =
          DateFormat(format, localization ?? HttpCalls.localization ?? 'en')
              .format(dateTime);
      return formatted;
    } catch (e) {
      return '00-00-0000';
    }
  }

  static DateTime pStringToDate(String date) {
    try {
      DateTime newDateTimeObj2 = DateTime.parse(date);
      return newDateTimeObj2;
    } catch (e) {
      return DateTime.now().subtract(const Duration(days: 9000));
    }
  }
}
