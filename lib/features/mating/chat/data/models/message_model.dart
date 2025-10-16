import '../../domain/entities/message_entity.dart';
import '../../domain/entities/message_status.dart';

class MessageModel extends MessageEntity {
  MessageModel({
    required super.id,
    required super.text,
    required super.isMe,
    required super.time,
    required super.status,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['id'],
      text: json['text'],
      isMe: json['isMe'],
      time: DateTime.parse(json['time']),
      status: MessageStatus.values.firstWhere(
            (e) => e.name == json['status'],
      ),
    );
  }




}
