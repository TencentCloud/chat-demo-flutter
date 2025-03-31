// ignore_for_file: unused_local_variable

library tencent_cloud_chat_intl;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tencent_cloud_chat_intl/localizations/tencent_cloud_chat_localizations.dart';

TencentCloudChatLocalizations tL10n = TencentCloudChatIntl().localization!;

class TencentCloudChatIntl extends ChangeNotifier {
  static TencentCloudChatIntl? _instance;

  static bool hasInitialized = false;

  TencentCloudChatIntl._internal(this._currentLocale);

  factory TencentCloudChatIntl({Locale? locale}) {
    _instance ??= TencentCloudChatIntl._internal(locale);
    return _instance!;
  }

  TencentCloudChatLocalizations? localization;
  Locale? _currentLocale;

  Locale getCurrentLocale(BuildContext context) {
    return _currentLocale ?? Localizations.localeOf(context);
  }

  init(BuildContext context) {
    if (hasInitialized) {
      return;
    }
    _currentLocale ??= Localizations.localeOf(context);
    localization = TencentCloudChatLocalizations.of(context);
    if (localization != null) {
      hasInitialized = true;
    }
  }

  void setLocale(Locale newLocale) {
    _currentLocale = newLocale;
    notifyListeners();
  }

  static String serializeLocale(Locale locale) {
    String languageCode = locale.languageCode;
    String countryCode = locale.countryCode ?? '';
    String scriptCode = locale.scriptCode ?? '';

    return '${languageCode}_${countryCode}_$scriptCode';
  }

  static Locale? deserializeLocale(String localeString) {
    if (localeString.isEmpty) {
      return null;
    }
    List<String> codes = localeString.split('_');
    String languageCode = codes[0];
    String countryCode = codes.length > 1 ? codes[1] : '';
    String scriptCode = codes.length > 2 ? codes[2] : '';

    return Locale.fromSubtags(
      languageCode: languageCode,
      countryCode: countryCode.isNotEmpty ? countryCode : null,
      scriptCode: scriptCode.isNotEmpty ? scriptCode : null,
    );
  }

  static String localizedDateString(int timestamp, BuildContext context) {
    Locale locale = TencentCloudChatIntl().getCurrentLocale(context);

    // Convert the timestamp (seconds) to a DateTime object
    DateTime date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);

    // Get the current year
    int currentYear = DateTime.now().year;

    // Choose the date format based on whether the date is in the current year
    DateFormat dateFormat = date.year == currentYear ? DateFormat.MMMMd(locale.toString()) : DateFormat.yMMMMd(locale.toString());

    // Format the date using the selected date format
    String dateString = dateFormat.format(date);

    return dateString;
  }

  /// Returns a formatted string representation of the current date and time.
  ///
  /// [dateTime] (optional) represents the date and time to format. If not provided, the current date and time will be used.
  ///
  /// Returns a string in the format "yyyy-MM-dd hh:mm:ss a".
  ///
  /// This function is used to format the date and time for logging purposes.
  ///
  /// Example:
  /// ```dart
  /// void main() {
  ///   /// Get the current formatted date and time
  ///   String formattedDateTime = getFormattedTimeString();
  ///
  ///   print("Current date and time: $formattedDateTime");
  /// }
  /// ```
  static String getFormattedTimeString({
    DateTime? dateTime,
  }) {
    // If dateTime is not provided, use the current date and time.
    dateTime ??= DateTime.now();

    // Create a DateFormat object for formatting the date and time.
    final dateFormat = DateFormat('yyyy-MM-dd hh:mm:ss a');

    // Format the DateTime object as a localized string and return it.
    return dateFormat.format(dateTime);
  }

  /// Formats a given timestamp (in seconds) into a time string in the format of "11:00 AM".
  ///
  /// This method takes an integer [timestamp] representing the number of seconds since the Unix epoch
  /// (January 1, 1970 at 00:00:00 UTC) and returns a formatted time string.
  ///
  /// The returned string will be in the format of "hh:mm a", where "hh" is the hour (00-11),
  /// "mm" is the minute (00-59), and "a" is either "AM" or "PM".
  ///
  /// Example:
  /// ```
  /// int timestamp = 1635504600; // Represents "2021-10-29 11:00:00"
  /// String formattedTime = formatTimestampToTime(timestamp);
  /// print(formattedTime); // Output: "11:00 AM"
  /// ```
  static String formatTimestampToTime(int timestamp) {
    // Convert the timestamp (in seconds) to a DateTime object.
    final dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);

    // Create a DateFormat object for formatting the time.
    final timeFormat = DateFormat.jm();

    // Format the DateTime object as a time string and return it.

    return timeFormat.format(dateTime);
  }

  /// Formats a given timestamp (in seconds) into a human-readable string based on different scenarios.
  ///
  /// This method takes an integer [timestamp] representing the number of seconds since the Unix epoch
  /// (January 1, 1970 at 00:00:00 UTC) and returns a human-readable string based on different scenarios:
  /// - If the timestamp and current time are on the same day, it returns the time in the current format (e.g., "11:00 AM").
  /// - If the timestamp is from yesterday, it returns "Yesterday".
  /// - If the timestamp is from before yesterday but in the same week, it returns the day of the week (e.g., "Monday").
  /// - If the timestamp is from before the current week but in the same year, it returns the date string without the year.
  /// - Otherwise, it returns the date string with the year.
  ///
  /// Example:
  /// ```
  /// int timestamp = 1635504600; // Represents "2021-10-29 11:00:00"
  /// String formattedTime = formatTimestampToHumanReadable(timestamp);
  /// print(formattedTime); // Output: "11:00 AM"
  /// ```
  static String formatTimestampToHumanReadable(int timestamp, BuildContext context) {
    Locale locale = TencentCloudChatIntl().getCurrentLocale(context);

    final now = DateTime.now();
    final dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    final timeFormat = DateFormat.jm(locale.toString());
    final dateFormat = DateFormat.yMMMMd(locale.toString());

    // Check if timestamp and now are on the same day
    if (dateTime.year == now.year &&
        dateTime.month == now.month &&
        dateTime.day == now.day) {
      return timeFormat.format(dateTime);
    }

    // Check if timestamp is from yesterday
    final yesterday = now.subtract(const Duration(days: 1));
    if (dateTime.year == yesterday.year &&
        dateTime.month == yesterday.month &&
        dateTime.day == yesterday.day) {
      return tL10n.yesterday;
    }

    // Check if timestamp is from before yesterday but in the same week
    if (dateTime.isAfter(now.subtract(const Duration(days: 6)))) {
      if(locale.languageCode == "en"){
        return DateFormat.E(locale.toString()).format(dateTime);
      }
      return DateFormat.EEEE(locale.toString()).format(dateTime);
    }

    // Check if timestamp is from before the current week but in the same year
    if (dateTime.year == now.year) {
      return DateFormat('MM/dd', locale.toString()).format(dateTime);
    }

    // Return the date string with the year for other cases
    return MaterialLocalizations.of(context).formatCompactDate(dateTime);
  }

  static String formatSeconds(int seconds) {
    String timeStr = '$seconds${tL10n.second}';

    if (seconds > 60) {
      int second = seconds % 60;
      int min = seconds ~/ 60;
      timeStr = '$min${tL10n.min}$second${tL10n.second}';

      if (min > 60) {
        min = (seconds ~/ 60) % 60;
        int hour = (seconds ~/ 60) ~/ 60;
        timeStr = '$hour${tL10n.hour}$min${tL10n.min}$second${tL10n.second}';

        if (hour % 24 == 0) {
          int day = ((seconds ~/ 60) ~/ 60) ~/ 24;
          timeStr = '$day${tL10n.day}';
        } else if (hour > 24) {
          hour = ((seconds ~/ 60) ~/ 60) % 24;
          int day = ((seconds ~/ 60) ~/ 60) ~/ 24;
          timeStr = '$day${tL10n.day}$hour${tL10n.hour}$min${tL10n.min}$second${tL10n.second}';
        }
      }
    }

    return timeStr;
  }

}
