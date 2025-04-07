import 'package:squeak/core/helper/image_helper/helper_model/response_model.dart';

class VerSionModel extends ResponseModel {

  final DataVersion data;
  VerSionModel({
    required super.errors,
    required super.message,
    required super.success,
    required super.statusCode,
    required this.data,
  });

  factory VerSionModel.fromJson(Map<String, dynamic> json) => VerSionModel(
        success: json["success"],
        errors:ResponseModel.convertJsonToMap(json),
        message: json["message"],
        statusCode: json["statusCode"],
        data: DataVersion.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "errors": errors,
        "message": message,
        "statusCode": statusCode,
        "data": data.toJson(),
      };
}

class DataVersion {
  final String version;
  final String link;
  final bool forceUpdate;
  DataVersion({
    required this.version,
    required this.link,
    required this.forceUpdate,
  });

  factory DataVersion.fromJson(Map<String, dynamic> json) => DataVersion(
        version: json["version"],
        link: json["link"],
        forceUpdate: json["forceToUpdate"],
      );


  Map<String, dynamic> toJson() => {
        "version": version,
        "link": link,
        "forceToUpdate": forceUpdate,
      };
}
