enum MessageStatus {
  sent, // 1 grey check - server received
  delivered, // 2 grey checks - recipient received
  seen, // 2 blue checks - recipient read
}

/// Helper to parse integer from backend
MessageStatus getStatusFromIndex(int index) {
  if (index >= 0 && index < MessageStatus.values.length) {
    return MessageStatus.values[index];
  }
  return MessageStatus.sent; // Default fallback
}

/// Helper to convert backend status to MessageStatus
MessageStatus getStatusFromBackend({
  required bool? isRead,
  String? deliveryStatus,
}) {
  if (isRead == true) {
    return MessageStatus.seen;
  }

  // Check delivery status from SignalR
  switch (deliveryStatus) {
    case 'one':
      return MessageStatus.sent;
    case 'two_grey':
      return MessageStatus.delivered;
    case 'two_colored':
      return MessageStatus.seen;
    default:
      return MessageStatus.sent;
  }
}
