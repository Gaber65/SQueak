
class NotificationMessage {
  dynamic senderId;
  dynamic category;
  dynamic collapseKey;
  dynamic contentAvailable;
  Data? data;
  String? from;
  String? messageId;
  dynamic messageType;
  dynamic mutableContent;
  dynamic notification;
  int? sentTime;
  dynamic threadId;
  int? ttl;

  NotificationMessage({this.senderId, this.category, this.collapseKey, this.contentAvailable, this.data, this.from, this.messageId, this.messageType, this.mutableContent, this.notification, this.sentTime, this.threadId, this.ttl});

  NotificationMessage.fromJson(Map<String, dynamic> json) {
    senderId = json["senderId"];
    category = json["category"];
    collapseKey = json["collapseKey"];
    contentAvailable = json["contentAvailable"];
    data = json["data"] == null ? null : Data.fromJson(json["data"]);
    from = json["from"];
    messageId = json["messageId"];
    messageType = json["messageType"];
    mutableContent = json["mutableContent"];
    notification = json["notification"];
    sentTime = json["sentTime"];
    threadId = json["threadId"];
    ttl = json["ttl"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["senderId"] = senderId;
    _data["category"] = category;
    _data["collapseKey"] = collapseKey;
    _data["contentAvailable"] = contentAvailable;
    if(data != null) {
      _data["data"] = data?.toJson();
    }
    _data["from"] = from;
    _data["messageId"] = messageId;
    _data["messageType"] = messageType;
    _data["mutableContent"] = mutableContent;
    _data["notification"] = notification;
    _data["sentTime"] = sentTime;
    _data["threadId"] = threadId;
    _data["ttl"] = ttl;
    return _data;
  }
}

class Data {
  dynamic contentAvailable;
  dynamic mutableContent;
  String? targetType;
  String? imageUrl;
  String? title;
  String? targetTypeId;
  String? body;

  Data({this.contentAvailable, this.mutableContent, this.targetType, this.imageUrl, this.title, this.targetTypeId, this.body});

  Data.fromJson(Map<String, dynamic> json) {
    contentAvailable = json["content_available"];
    mutableContent = json["mutable_content"];
    targetType = json["TargetType"];
    imageUrl = json["ImageUrl"];
    title = json["Title"];
    targetTypeId = json["TargetTypeId"];
    body = json["Body"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["content_available"] = contentAvailable;
    _data["mutable_content"] = mutableContent;
    _data["TargetType"] = targetType;
    _data["ImageUrl"] = imageUrl;
    _data["Title"] = title;
    _data["TargetTypeId"] = targetTypeId;
    _data["Body"] = body;
    return _data;
  }
}