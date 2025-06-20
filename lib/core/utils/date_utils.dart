import 'package:intl/intl.dart';

class AppDateUtils {
  // Date formatters
  static final DateFormat dayMonthYear = DateFormat('dd/MM/yyyy');
  static final DateFormat monthDayYear = DateFormat('MMM d, yyyy');
  static final DateFormat dayName = DateFormat('EEEE');
  static final DateFormat shortDayName = DateFormat('EEE');
  static final DateFormat monthName = DateFormat('MMMM');
  static final DateFormat shortMonthName = DateFormat('MMM');
  static final DateFormat time24 = DateFormat('HH:mm');
  static final DateFormat time12 = DateFormat('h:mm a');
  static final DateFormat dateTime = DateFormat('MMM d, yyyy HH:mm');
  static final DateFormat iso8601 = DateFormat('yyyy-MM-ddTHH:mm:ss');

  /// Check if two dates are on the same day
  static bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
           date1.month == date2.month &&
           date1.day == date2.day;
  }

  /// Check if date is today
  static bool isToday(DateTime date) {
    return isSameDay(date, DateTime.now());
  }

  /// Check if date is tomorrow
  static bool isTomorrow(DateTime date) {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return isSameDay(date, tomorrow);
  }

  /// Check if date is yesterday
  static bool isYesterday(DateTime date) {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return isSameDay(date, yesterday);
  }

  /// Get relative day name (Today, Tomorrow, Yesterday, or day name)
  static String getRelativeDayName(DateTime date) {
    if (isToday(date)) return 'Today';
    if (isTomorrow(date)) return 'Tomorrow';
    if (isYesterday(date)) return 'Yesterday';
    return dayName.format(date);
  }

  /// Get short relative day name
  static String getShortRelativeDayName(DateTime date) {
    if (isToday(date)) return 'Today';
    if (isTomorrow(date)) return 'Tomorrow';
    if (isYesterday(date)) return 'Yesterday';
    return shortDayName.format(date);
  }

  /// Get time ago string
  static String getTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 365) {
      final years = (difference.inDays / 365).floor();
      return '${years}y ago';
    } else if (difference.inDays > 30) {
      final months = (difference.inDays / 30).floor();
      return '${months}mo ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }

  /// Get duration string
  static String getDurationString(Duration duration) {
    if (duration.inDays > 0) {
      return '${duration.inDays}d ${duration.inHours % 24}h';
    } else if (duration.inHours > 0) {
      return '${duration.inHours}h ${duration.inMinutes % 60}m';
    } else if (duration.inMinutes > 0) {
      return '${duration.inMinutes}m';
    } else {
      return '${duration.inSeconds}s';
    }
  }

  /// Get first day of month
  static DateTime getFirstDayOfMonth(DateTime date) {
    return DateTime(date.year, date.month, 1);
  }

  /// Get last day of month
  static DateTime getLastDayOfMonth(DateTime date) {
    return DateTime(date.year, date.month + 1, 0);
  }

  /// Get first day of week (Monday)
  static DateTime getFirstDayOfWeek(DateTime date) {
    final daysFromMonday = date.weekday - 1;
    return date.subtract(Duration(days: daysFromMonday));
  }

  /// Get last day of week (Sunday)
  static DateTime getLastDayOfWeek(DateTime date) {
    final daysToSunday = 7 - date.weekday;
    return date.add(Duration(days: daysToSunday));
  }

  /// Get days in month
  static int getDaysInMonth(int year, int month) {
    return DateTime(year, month + 1, 0).day;
  }

  /// Check if year is leap year
  static bool isLeapYear(int year) {
    return (year % 4 == 0 && year % 100 != 0) || (year % 400 == 0);
  }

  /// Get age from birth date
  static int getAge(DateTime birthDate) {
    final now = DateTime.now();
    int age = now.year - birthDate.year;

    if (now.month < birthDate.month ||
        (now.month == birthDate.month && now.day < birthDate.day)) {
      age--;
    }

    return age;
  }

  /// Get week number of year
  static int getWeekNumber(DateTime date) {
    final firstDayOfYear = DateTime(date.year, 1, 1);
    final dayOfYear = date.difference(firstDayOfYear).inDays + 1;
    return ((dayOfYear - date.weekday + 10) / 7).floor();
  }

  /// Get quarter of year
  static int getQuarter(DateTime date) {
    return ((date.month - 1) / 3).floor() + 1;
  }

  /// Get start of day
  static DateTime getStartOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  /// Get end of day
  static DateTime getEndOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day, 23, 59, 59, 999);
  }

  /// Add business days
  static DateTime addBusinessDays(DateTime date, int businessDays) {
    var result = date;
    var daysToAdd = businessDays;

    while (daysToAdd > 0) {
      result = result.add(const Duration(days: 1));
      if (result.weekday < 6) { // Monday to Friday
        daysToAdd--;
      }
    }

    return result;
  }

  /// Get business days between dates
  static int getBusinessDaysBetween(DateTime start, DateTime end) {
    var count = 0;
    var current = start;

    while (current.isBefore(end)) {
      if (current.weekday < 6) { // Monday to Friday
        count++;
      }
      current = current.add(const Duration(days: 1));
    }

    return count;
  }

  /// Format duration in human readable format
  static String formatDuration(Duration duration) {
    final days = duration.inDays;
    final hours = duration.inHours % 24;
    final minutes = duration.inMinutes % 60;

    if (days > 0) {
      return '$days days, $hours hours';
    } else if (hours > 0) {
      return '$hours hours, $minutes minutes';
    } else {
      return '$minutes minutes';
    }
  }

  /// Get date range string
  static String formatDateRange(DateTime start, DateTime end) {
    if (isSameDay(start, end)) {
      return monthDayYear.format(start);
    } else if (start.year == end.year && start.month == end.month) {
      return '${start.day} - ${end.day} ${shortMonthName.format(start)} ${start.year}';
    } else if (start.year == end.year) {
      return '${shortMonthName.format(start)} ${start.day} - ${shortMonthName.format(end)} ${end.day}, ${start.year}';
    } else {
      return '${monthDayYear.format(start)} - ${monthDayYear.format(end)}';
    }
  }

  /// Convert string to DateTime
  static DateTime? parseDate(String dateString, {String? format}) {
    try {
      if (format != null) {
        return DateFormat(format).parse(dateString);
      } else {
        return DateTime.parse(dateString);
      }
    } catch (e) {
      return null;
    }
  }

  /// Get timezone offset in hours
  static double getTimezoneOffset() {
    return DateTime.now().timeZoneOffset.inHours.toDouble();
  }

  /// Convert to UTC
  static DateTime toUtc(DateTime dateTime) {
    return dateTime.toUtc();
  }

  /// Convert from UTC to local
  static DateTime fromUtc(DateTime utcDateTime) {
    return utcDateTime.toLocal();
  }

  /// Get season from date
  static String getSeason(DateTime date) {
    final month = date.month;
    if (month >= 3 && month <= 5) return 'Spring';
    if (month >= 6 && month <= 8) return 'Summer';
    if (month >= 9 && month <= 11) return 'Autumn';
    return 'Winter';
  }

  /// Check if date is weekend
  static bool isWeekend(DateTime date) {
    return date.weekday == DateTime.saturday || date.weekday == DateTime.sunday;
  }

  /// Get next weekday
  static DateTime getNextWeekday(DateTime date, int weekday) {
    var result = date;
    while (result.weekday != weekday) {
      result = result.add(const Duration(days: 1));
    }
    return result;
  }

  /// Get previous weekday
  static DateTime getPreviousWeekday(DateTime date, int weekday) {
    var result = date;
    while (result.weekday != weekday) {
      result = result.subtract(const Duration(days: 1));
    }
    return result;
  }

  /// Get Islamic months
  static List<String> getIslamicMonths() {
    return [
      'Muharram',
      'Safar',
      'Rabi\' al-awwal',
      'Rabi\' al-thani',
      'Jumada al-awwal',
      'Jumada al-thani',
      'Rajab',
      'Sha\'ban',
      'Ramadan',
      'Shawwal',
      'Dhu al-Qi\'dah',
      'Dhu al-Hijjah',
    ];
  }

  /// Get prayer time names
  static List<String> getPrayerNames() {
    return ['Fajr', 'Sunrise', 'Dhuhr', 'Asr', 'Maghrib', 'Isha'];
  }

  /// Format time with preference (12h or 24h)
  static String formatTimeWithPreference(DateTime time, {bool use24Hour = true}) {
    return use24Hour ? time24.format(time) : time12.format(time);
  }

  /// Get friendly date string
  static String getFriendlyDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date).inDays;

    if (difference == 0) return 'Today';
    if (difference == 1) return 'Yesterday';
    if (difference < 7) return '$difference days ago';
    if (difference < 30) return '${(difference / 7).floor()} weeks ago';
    if (difference < 365) return '${(difference / 30).floor()} months ago';
    return '${(difference / 365).floor()} years ago';
  }

  /// Get remaining time string
  static String getRemainingTime(DateTime targetTime) {
    final now = DateTime.now();
    final difference = targetTime.difference(now);

    if (difference.isNegative) return 'Past due';

    if (difference.inDays > 0) {
      return '${difference.inDays}d ${difference.inHours % 24}h remaining';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ${difference.inMinutes % 60}m remaining';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m remaining';
    } else {
      return 'Less than a minute';
    }
  }
}
