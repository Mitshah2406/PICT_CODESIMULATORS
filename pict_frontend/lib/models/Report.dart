import 'dart:convert';

Report reportFromJson(String str) => Report.fromJson(json.decode(str));

String reportToJson(Report data) => json.encode(data.toJson());

class Report {
  String? id;
  String? uploaderId;
  String? uploaderName;
  String? uploaderEmail;
  String? description;
  Location? location;
  String? reportAttachment;
  String? reportStatus;
  DateTime? createdOn;

  Report({
    this.id,
    this.uploaderId,
    this.uploaderName,
    this.uploaderEmail,
    this.description,
    this.location,
    this.reportAttachment,
    this.reportStatus,
    this.createdOn,
  });

  factory Report.fromJson(Map<String, dynamic> json) => Report(
        id: json["_id"],
        uploaderId: json["uploaderId"],
        uploaderName: json["uploaderName"],
        uploaderEmail: json["uploaderEmail"],
        description: json["description"],
        location: json["location"] == null
            ? null
            : Location.fromJson(json["location"]),
        reportAttachment: json["reportAttachment"],
        reportStatus: json["reportStatus"],
        createdOn: json["createdOn"] == null
            ? null
            : DateTime.parse(json["createdOn"]),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "uploaderId": uploaderId,
        "uploaderName": uploaderName,
        "uploaderEmail": uploaderEmail,
        "description": description,
        "location": location?.toJson(),
        "reportAttachment": reportAttachment,
        "reportStatus": reportStatus,
        "createdOn": createdOn?.toIso8601String(),
      };
}

class Location {
  String? lat;
  String? lon;
  String? formattedAddress;

  Location({
    this.lat,
    this.lon,
    this.formattedAddress,
  });

  factory Location.fromJson(Map<String, dynamic> json) => Location(
        lat: json["lat"],
        lon: json["lon"],
        formattedAddress: json["formattedAddress"],
      );

  Map<String, dynamic> toJson() => {
        "lat": lat,
        "lon": lon,
        "formattedAddress": formattedAddress,
      };
}
