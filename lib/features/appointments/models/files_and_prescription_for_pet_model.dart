






// To parse this JSON data, do
//
//     final prescriptionAndFiles = prescriptionAndFilesFromJson(jsonString);

import 'dart:convert';

PrescriptionAndFiles prescriptionAndFilesFromJson(String str) => PrescriptionAndFiles.fromJson(json.decode(str));

String prescriptionAndFilesToJson(PrescriptionAndFiles data) => json.encode(data.toJson());

class PrescriptionAndFiles {
  bool? success;
  Errors? errors;
  Data? data;
  String? message;
  int? statusCode;

  PrescriptionAndFiles({
    this.success,
    this.errors,
    this.data,
    this.message,
    this.statusCode,
  });

  factory PrescriptionAndFiles.fromJson(Map<String, dynamic> json) => PrescriptionAndFiles(
    success: json["success"],
    errors: json["errors"] == null ? null : Errors.fromJson(json["errors"]),
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
    message: json["message"],
    statusCode: json["statusCode"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "errors": errors?.toJson(),
    "data": data?.toJson(),
    "message": message,
    "statusCode": statusCode,
  };
}

class Data {
  List<FileElement>? files;
  Prescription? prescription;

  Data({
    this.files,
    this.prescription,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    files: json["files"] == null ? [] : List<FileElement>.from(json["files"]!.map((x) => FileElement.fromJson(x))),
    prescription: json["prescription"] == null ? null : Prescription.fromJson(json["prescription"]),
  );

  Map<String, dynamic> toJson() => {
    "files": files == null ? [] : List<dynamic>.from(files!.map((x) => x.toJson())),
    "prescription": prescription?.toJson(),
  };
}

class FileElement {
  String? name;
  String? fileLink;
  String? description;
  DateTime? issueDate;

  FileElement({
    this.name,
    this.fileLink,
    this.description,
    this.issueDate,
  });

  factory FileElement.fromJson(Map<String, dynamic> json) => FileElement(
    name: json["name"],
    fileLink: json["fileLink"],
    description: json["description"],
    issueDate: json["issueDate"] == null ? null : DateTime.parse(json["issueDate"]),
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "fileLink": fileLink,
    "description": description,
    "issueDate": issueDate?.toIso8601String(),
  };
}

class Prescription {
  String? comment;
  DateTime? date;
  List<PrescriptionDrug>? prescriptionDrugs;

  Prescription({
    this.comment,
    this.date,
    this.prescriptionDrugs,
  });

  factory Prescription.fromJson(Map<String, dynamic> json) => Prescription(
    comment: json["comment"],
    date: json["date"] == null ? null : DateTime.parse(json["date"]),
    prescriptionDrugs: json["prescriptionDrugs"] == null ? [] : List<PrescriptionDrug>.from(json["prescriptionDrugs"]!.map((x) => PrescriptionDrug.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "comment": comment,
    "date": date?.toIso8601String(),
    "prescriptionDrugs": prescriptionDrugs == null ? [] : List<dynamic>.from(prescriptionDrugs!.map((x) => x.toJson())),
  };
}

class PrescriptionDrug {
  String? numberOfUnit;
  int? numberOfTime;
  int? numberOfDay;
  Drug? drug;

  PrescriptionDrug({
    this.numberOfUnit,
    this.numberOfTime,
    this.numberOfDay,
    this.drug,
  });

  factory PrescriptionDrug.fromJson(Map<String, dynamic> json) => PrescriptionDrug(
    numberOfUnit: json["numberOfUnit"],
    numberOfTime: json["numberOfTime"],
    numberOfDay: json["numberOfDay"],
    drug: json["drug"] == null ? null : Drug.fromJson(json["drug"]),
  );

  Map<String, dynamic> toJson() => {
    "numberOfUnit": numberOfUnit,
    "numberOfTime": numberOfTime,
    "numberOfDay": numberOfDay,
    "drug": drug?.toJson(),
  };
}

class Drug {
  String? name;
  String? description;

  Drug({
    this.name,
    this.description,
  });

  factory Drug.fromJson(Map<String, dynamic> json) => Drug(
    name: json["name"],
    description: json["description"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "description": description,
  };
}

class Errors {
  Errors();

  factory Errors.fromJson(Map<String, dynamic> json) => Errors(
  );

  Map<String, dynamic> toJson() => {
  };
}





























// import 'dart:convert';
//
// import '../../../core/helper/image_helper/helper_model/response_model.dart';
//
//
//
//
// class GetPrescriptionAndFilesModel extends ResponseModel {
//   final PrescriptionAndFilesModel? data;
//
//   GetPrescriptionAndFilesModel({
//     required this.data,
//     required super.errors,
//     required super.message,
//     required super.statusCode,
//     required super.success,
//   });
//
//   factory GetPrescriptionAndFilesModel.fromJson(Map<String, dynamic> json) {
//     return GetPrescriptionAndFilesModel(
//       data: json['data'] != null ? PrescriptionAndFilesModel.fromJson(json['data']) : null,
//       errors: Map<String, List<dynamic>>.from(json['errors']),
//       message: json['message'],
//       statusCode: json['statusCode'],
//       success: json['success'],
//     );
//   }
// }
//
// PrescriptionAndFilesModel prescriptionAndFilesModelFromJson(String str) => PrescriptionAndFilesModel.fromJson(json.decode(str));
//
// String prescriptionAndFilesModelToJson(PrescriptionAndFilesModel data) => json.encode(data.toJson());
//
// class PrescriptionAndFilesModel {
//   Data? data;
//
//   PrescriptionAndFilesModel({
//     this.data,
//   });
//
//   factory PrescriptionAndFilesModel.fromJson(Map<String, dynamic> json) => PrescriptionAndFilesModel(
//     data: json["data"] == null ? null : Data.fromJson(json["data"]),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "data": data?.toJson(),
//   };
// }
//
// class Data {
//   List<FileElement>? files;
//   Prescription? prescription;
//
//   Data({
//     this.files,
//     this.prescription,
//   });
//
//   factory Data.fromJson(Map<String, dynamic> json) => Data(
//     files: json["files"] == null ? [] : List<FileElement>.from(json["files"]!.map((x) => FileElement.fromJson(x))),
//     prescription: json["prescription"] == null ? null : Prescription.fromJson(json["prescription"]),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "files": files == null ? [] : List<dynamic>.from(files!.map((x) => x.toJson())),
//     "prescription": prescription?.toJson(),
//   };
// }
//
// class FileElement {
//   String? name;
//   String? fileLink;
//   String? description;
//   DateTime? issueDate;
//
//   FileElement({
//     this.name,
//     this.fileLink,
//     this.description,
//     this.issueDate,
//   });
//
//   factory FileElement.fromJson(Map<String, dynamic> json) => FileElement(
//     name: json["name"],
//     fileLink: json["fileLink"],
//     description: json["description"],
//     issueDate: json["issueDate"] == null ? null : DateTime.parse(json["issueDate"]),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "name": name,
//     "fileLink": fileLink,
//     "description": description,
//     "issueDate": issueDate?.toIso8601String(),
//   };
// }
//
// class Prescription {
//   String? comment;
//   DateTime? date;
//   List<PrescriptionDrug>? prescriptionDrugs;
//
//   Prescription({
//     this.comment,
//     this.date,
//     this.prescriptionDrugs,
//   });
//
//   factory Prescription.fromJson(Map<String, dynamic> json) => Prescription(
//     comment: json["comment"],
//     date: json["date"] == null ? null : DateTime.parse(json["date"]),
//     prescriptionDrugs: json["prescriptionDrugs"] == null ? [] : List<PrescriptionDrug>.from(json["prescriptionDrugs"]!.map((x) => PrescriptionDrug.fromJson(x))),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "comment": comment,
//     "date": date?.toIso8601String(),
//     "prescriptionDrugs": prescriptionDrugs == null ? [] : List<dynamic>.from(prescriptionDrugs!.map((x) => x.toJson())),
//   };
// }
//
// class PrescriptionDrug {
//   String? numberOfUnit;
//   int? numberOfTime;
//   int? numberOfDay;
//   Drug? drug;
//
//   PrescriptionDrug({
//     this.numberOfUnit,
//     this.numberOfTime,
//     this.numberOfDay,
//     this.drug,
//   });
//
//   factory PrescriptionDrug.fromJson(Map<String, dynamic> json) => PrescriptionDrug(
//     numberOfUnit: json["numberOfUnit"],
//     numberOfTime: json["numberOfTime"],
//     numberOfDay: json["numberOfDay"],
//     drug: json["drug"] == null ? null : Drug.fromJson(json["drug"]),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "numberOfUnit": numberOfUnit,
//     "numberOfTime": numberOfTime,
//     "numberOfDay": numberOfDay,
//     "drug": drug?.toJson(),
//   };
// }
//
// class Drug {
//   String? name;
//   String? description;
//
//   Drug({
//     this.name,
//     this.description,
//   });
//
//   factory Drug.fromJson(Map<String, dynamic> json) => Drug(
//     name: json["name"],
//     description: json["description"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "name": name,
//     "description": description,
//   };
// }
//
//
