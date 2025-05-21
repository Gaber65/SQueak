import 'package:squeak/core/utils/export_path/export_files.dart';



class FirebaseMessagingHandler {
  @pragma('vm:entry-point')
  static void handleNotification(
      String title,
      String body,
      String imageUrl,
      String targetTypeId,
      String targetType,
      ) {
    print(
        'function use to handetitle: $title, body: $body, imageUrl: $imageUrl, targetTypeId: $targetTypeId, targetType: $targetType');
    scheduleNotification(
      title: title,
      body: body,
      id: targetTypeId,
      largeImageUrl: imageUrl,
      typeName: targetType,
    );
  }

  static NotificationType? getNotificationType(String typeName) {
    for (NotificationType type in NotificationType.values) {
      if (type.typeName == typeName) {
        return type;
      }
    }
    return null; // If no match is found
  }
}

