 import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

class Dates {

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

   static DateFormat pDateFormatter() {
     return  DateFormat(pGetDate);
   }

   static DateFormat pDateTimeFormatter() {
     return DateFormat(pGetDateTime);
   }

   static DateFormat pDateFormatterForSend() {
     return DateFormat('yyyy-MM-dd');
   }

   static String sDateToStringForSend(DateTime dateTime) {
     String formatted = pDateFormatterForSend().format(dateTime);
//    print(formatted); // something like 2013-04-20
     return formatted;
   }
   static String pDateToString(DateTime dateTime) {
     try{
       String formatted = pDateFormatter().format(dateTime);
       return formatted;
     }catch (e){
       return '00-00-0000';
     }

   }

   static String pDateTimeToString(DateTime dateTime) {
     try{
       String formatted = pDateTimeFormatter().format(dateTime);
       return formatted;
     }catch (e){
       if (kDebugMode) {
         print(e.toString());
       }
       return '00-00-0000';
     }

   }

   static String pGetDateTimeCustomFormat(DateTime dateTime, String format) {
     try{
       String formatted = DateFormat(format).format(dateTime);
       return formatted;
     }catch (e){
       return '00-00-0000';
     }

   }



   static DateTime pStringToDate(String date) {
     try{
       DateTime newDateTimeObj2 = DateTime.parse(date);
       return newDateTimeObj2;
     }catch (e){
       return DateTime.now().subtract(const Duration(days: 9000));
     }

   }


 }