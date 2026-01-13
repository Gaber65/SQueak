import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:squeak/generated/l10n.dart';

class DateTimeFormatter {

  static String formattedTime(DateTime dt, [String? locale]) {
    final loc = locale ?? Intl.getCurrentLocale();
    try {
      return DateFormat.jm(loc).format(dt);
    } catch (_) {
      return DateFormat.Hm().format(dt);
    }
  }

  static String formattedDateTime(DateTime dt, [String? locale]) {
    final loc = locale ?? Intl.getCurrentLocale();
    try {
      return DateFormat.yMd(loc).add_jm().format(dt);
    } catch (_) {
      return DateFormat('yyyy-MM-dd HH:mm').format(dt);
    }
  }

  /// Returns a WhatsApp-style time display that shows:
  /// - Time only (e.g., "5:30 PM") for messages from today
  /// - "Yesterday" for messages from yesterday
  /// - Date (e.g., "11/1/2025") for older messages
  /// Respects device locale/timezone automatically.
  static String formattedChatTime(DateTime dt, {BuildContext? context}) {
    final now = DateTime.now();
    final messageDate = dt;

    // Get locale
    final locale =
        context != null
            ? Localizations.localeOf(context).toString()
            : Intl.getCurrentLocale();

    // Check if it's today
    if (now.year == messageDate.year &&
        now.month == messageDate.month &&
        now.day == messageDate.day) {
      // Show time only for today's messages
      try {
        return DateFormat.jm(locale).format(messageDate);
      } catch (_) {
        return DateFormat.Hm().format(messageDate);
      }
    }

    // Check if it's yesterday
    final yesterday = now.subtract(const Duration(days: 1));
    if (yesterday.year == messageDate.year &&
        yesterday.month == messageDate.month &&
        yesterday.day == messageDate.day) {
      return context != null ? S.of(context).yesterday : 'Yesterday';
    }

    // Show date for older messages
    try {
      return DateFormat.yMd(locale).format(messageDate);
    } catch (_) {
      return DateFormat('yyyy-MM-dd').format(messageDate);
    }
  }

  /// Returns a relative time string. If [context] is provided, localized
  /// labels from `S.of(context)` are used (e.g. localized "just now").
  /// [reference] can be provided for deterministic testing.
  static String formattedRelativeTime(
    DateTime dt, {
    BuildContext? context,
    DateTime? reference,
  }) {
    final now = (reference ?? DateTime.now()).toUtc();
    final then = dt.toUtc();
    final diff = now.difference(then);

    final justNowLabel = context != null ? S.of(context).justNow : 'just now';
    final yesterdayLabel =
        context != null ? S.of(context).yesterday : 'yesterday';

    if (diff.inSeconds < 5) return justNowLabel;
    if (diff.inSeconds < 60) return '${diff.inSeconds}s';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m';
    if (diff.inHours < 24) return '${diff.inHours}h';

    final days = diff.inDays;
    if (days == 1) return yesterdayLabel;
    if (days < 7) return '${days}d';

    // Fallback to a short date (localized if possible)
    // Note: dt is already in local time from entity
    try {
      return DateFormat.yMd(
        context != null
            ? Localizations.localeOf(context).toString()
            : Intl.getCurrentLocale(),
      ).format(dt);
    } catch (_) {
      return DateFormat('yyyy-MM-dd').format(dt);
    }
  }
}
