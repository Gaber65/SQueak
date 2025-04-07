// notification_receive.dart

class NotificationReceive {
  final String targetType;
  final String targetTypeId;

  NotificationReceive({
    required this.targetType,
    required this.targetTypeId,
  });

  factory NotificationReceive.fromJson(Map<String, dynamic> json) {
    return NotificationReceive(
      targetType: json['TargetType'],
      targetTypeId: json['TargetTypeId'],
    );
  }
}
