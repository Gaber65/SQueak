import 'package:flutter/material.dart';

import '../../../../../core/service/global_function/format_utils.dart';

enum BoardingStatus {
  inProgress, // 0
  closed, // 1
  paid, // 2
  all, // 3
  reserved, // 4
  cancelled, // 5
}

extension BoardingStatusExtension on BoardingStatus {
  static BoardingStatus fromInt(int value) {
    switch (value) {
      case 0:
        return BoardingStatus.inProgress;
      case 1:
        return BoardingStatus.closed;
      case 2:
        return BoardingStatus.paid;
      case 3:
        return BoardingStatus.all;
      case 4:
        return BoardingStatus.reserved;
      case 5:
        return BoardingStatus.cancelled;
      default:
        throw ArgumentError('Invalid BoardingStatus value: $value');
    }
  }

  static const _statusTextEn = {
    BoardingStatus.inProgress: 'In Progress',
    BoardingStatus.closed: 'Closed',
    BoardingStatus.paid: 'Paid',
    BoardingStatus.all: 'All',
    BoardingStatus.reserved: 'Reserved',
    BoardingStatus.cancelled: 'Cancelled',
  };

  static const _statusTextAr = {
    BoardingStatus.inProgress: 'قيد التقدم',
    BoardingStatus.closed: 'مغلق',
    BoardingStatus.paid: 'مدفوع',
    BoardingStatus.all: 'الكل',
    BoardingStatus.reserved: 'محجوز',
    BoardingStatus.cancelled: 'ملغى',
  };

  String getDisplayText(bool isArabic) {
    return isArabic ? _statusTextAr[this]! : _statusTextEn[this]!;
  }

  Color getChipColor() {
    switch (this) {
      case BoardingStatus.inProgress:
        return Colors.orange.withOpacity(0.1);
      case BoardingStatus.closed:
        return Colors.red.withOpacity(0.1);
      case BoardingStatus.paid:
        return Colors.green.withOpacity(0.1);
      case BoardingStatus.reserved:
        return Colors.blue.withOpacity(0.1);
      case BoardingStatus.cancelled:
        return Colors.grey.withOpacity(0.1);
      default:
        return Colors.black.withOpacity(0.1);
    }
  }

  Color getTextColor() {
    switch (this) {
      case BoardingStatus.inProgress:
        return Colors.orange[800]!;
      case BoardingStatus.closed:
        return Colors.red[800]!;
      case BoardingStatus.paid:
        return Colors.green[800]!;
      case BoardingStatus.reserved:
        return Colors.blue[800]!;
      case BoardingStatus.cancelled:
        return Colors.grey[800]!;
      default:
        return Colors.black;
    }
  }
}


class StateBoarding {
  final BoardingStatus state;
  final String key;

  StateBoarding(this.state, this.key);
}



List<StateBoarding> generateDummyDataStateForBoarding(BuildContext context) {
  bool arabicLanguage = isArabic();

  return [
    StateBoarding(
      BoardingStatus.inProgress,
      arabicLanguage ? 'قيد التقدم' : 'In Progress',
    ),
    StateBoarding(
      BoardingStatus.closed,
      arabicLanguage ? 'مغلق' : 'Closed',
    ),
    StateBoarding(
      BoardingStatus.paid,
      arabicLanguage ? 'مدفوع' : 'Paid',
    ),
    StateBoarding(
      BoardingStatus.all,
      arabicLanguage ? 'الكل' : 'All',
    ),
    StateBoarding(
      BoardingStatus.reserved,
      arabicLanguage ? 'محجوز' : 'Reserved',
    ),
    StateBoarding(
      BoardingStatus.cancelled,
      arabicLanguage ? 'ملغى' : 'Cancelled',
    ),
  ];
}