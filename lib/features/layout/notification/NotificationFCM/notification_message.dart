
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data["senderId"] = senderId;
    data["category"] = category;
    data["collapseKey"] = collapseKey;
    data["contentAvailable"] = contentAvailable;
    if(data != null) {
      data["data"] = data?.toJson();
    }
    data["from"] = from;
    data["messageId"] = messageId;
    data["messageType"] = messageType;
    data["mutableContent"] = mutableContent;
    data["notification"] = notification;
    data["sentTime"] = sentTime;
    data["threadId"] = threadId;
    data["ttl"] = ttl;
    return data;
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data["content_available"] = contentAvailable;
    data["mutable_content"] = mutableContent;
    data["TargetType"] = targetType;
    data["ImageUrl"] = imageUrl;
    data["Title"] = title;
    data["TargetTypeId"] = targetTypeId;
    data["Body"] = body;
    return data;
  }
}