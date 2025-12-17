// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:squeak/core/service/global_function/format_utils.dart'
    show isArabic;

enum BoardingStatusEnums {
  inProgress, // 0
  closed, // 1
  paid, // 2
  all, // 3
  reserved, // 4
  cancelled, // 5
}

extension BoardingStatusExtension on BoardingStatusEnums {
  static BoardingStatusEnums fromInt(int value) {
    switch (value) {
      case 0:
        return BoardingStatusEnums.inProgress;
      case 1:
        return BoardingStatusEnums.closed;
      case 2:
        return BoardingStatusEnums.paid;
      case 3:
        return BoardingStatusEnums.all;
      case 4:
        return BoardingStatusEnums.reserved;
      case 5:
        return BoardingStatusEnums.cancelled;
      default:
        throw ArgumentError('Invalid BoardingStatus value: $value');
    }
  }

  static const _statusTextEn = {
    BoardingStatusEnums.inProgress: 'In Progress',
    BoardingStatusEnums.closed: 'Closed',
    BoardingStatusEnums.paid: 'Paid',
    BoardingStatusEnums.all: 'All',
    BoardingStatusEnums.reserved: 'Reserved',
    BoardingStatusEnums.cancelled: 'Cancelled',
  };

  static const _statusTextAr = {
    BoardingStatusEnums.inProgress: 'قيد التقدم',
    BoardingStatusEnums.closed: 'مغلق',
    BoardingStatusEnums.paid: 'مدفوع',
    BoardingStatusEnums.all: 'الكل',
    BoardingStatusEnums.reserved: 'محجوز',
    BoardingStatusEnums.cancelled: 'ملغى',
  };

  String getDisplayText(bool isArabic) {
    return isArabic ? _statusTextAr[this]! : _statusTextEn[this]!;
  }

  Color getChipColor() {
    switch (this) {
      case BoardingStatusEnums.inProgress:
        return Colors.orange.withOpacity(0.1);
      case BoardingStatusEnums.closed:
        return Colors.red.withOpacity(0.1);
      case BoardingStatusEnums.paid:
        return Colors.green.withOpacity(0.1);
      case BoardingStatusEnums.reserved:
        return Colors.blue.withOpacity(0.1);
      case BoardingStatusEnums.cancelled:
        return Colors.grey.withOpacity(0.1);
      default:
        return Colors.black.withOpacity(0.1);
    }
  }

  Color getTextColor() {
    switch (this) {
      case BoardingStatusEnums.inProgress:
        return Colors.orange[800]!;
      case BoardingStatusEnums.closed:
        return Colors.red[800]!;
      case BoardingStatusEnums.paid:
        return Colors.green[800]!;
      case BoardingStatusEnums.reserved:
        return Colors.blue[800]!;
      case BoardingStatusEnums.cancelled:
        return Colors.grey[800]!;
      default:
        return Colors.black;
    }
  }
}

class StateBoardingEnums {
  final BoardingStatusEnums state;
  final String key;

  StateBoardingEnums(this.state, this.key);
}

List<StateBoardingEnums> generateDummyDataStateForBoarding(
  BuildContext context,
) {
  bool arabicLanguage = isArabic();

  return [
    StateBoardingEnums(
      BoardingStatusEnums.inProgress,
      arabicLanguage ? 'قيد التقدم' : 'In Progress',
    ),
    StateBoardingEnums(
      BoardingStatusEnums.closed,
      arabicLanguage ? 'مغلق' : 'Closed',
    ),
    StateBoardingEnums(
      BoardingStatusEnums.paid,
      arabicLanguage ? 'مدفوع' : 'Paid',
    ),
    StateBoardingEnums(
      BoardingStatusEnums.all,
      arabicLanguage ? 'الكل' : 'All',
    ),
    StateBoardingEnums(
      BoardingStatusEnums.reserved,
      arabicLanguage ? 'محجوز' : 'Reserved',
    ),
    StateBoardingEnums(
      BoardingStatusEnums.cancelled,
      arabicLanguage ? 'ملغى' : 'Cancelled',
    ),
  ];
}
