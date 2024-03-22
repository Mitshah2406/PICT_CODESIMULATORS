// To parse this JSON data, do
//
//     final event = eventFromJson(jsonString);

import 'dart:convert';

Event eventFromJson(String str) => Event.fromJson(json.decode(str));

String eventToJson(Event data) => json.encode(data.toJson());

class Event {
  String? id;
  String? eventName;
  String? eventDescription;
  String? eventPoster;
  DateTime? eventStartDate;
  String? eventStartTime;
  DateTime? eventEndDate;
  String? eventEndTime;
  String? collabOrganizationName;
  String? collabOrgEmail;
  List<String>? eventAttachment;
  String? organizerName;
  String? organizerEmail;
  String? organizerNumber;
  String? whatsAppLink;
  int? noOfVolunteersNeeded;
  List<dynamic>? volunteerResponsibilities;
  String? eventAddress;
  String? eventCity;
  String? participationCertificateTemplate;
  String? volunteerCertificateTemplate;
  List<dynamic>? volunteers;
  List<dynamic>? registeredParticipants;
  List<dynamic>? presentParticipants;

  Event({
    this.id,
    this.eventName,
    this.eventDescription,
    this.eventPoster,
    this.eventStartDate,
    this.eventStartTime,
    this.eventEndDate,
    this.eventEndTime,
    this.collabOrganizationName,
    this.collabOrgEmail,
    this.eventAttachment,
    this.organizerName,
    this.organizerEmail,
    this.organizerNumber,
    this.whatsAppLink,
    this.noOfVolunteersNeeded,
    this.volunteerResponsibilities,
    this.eventAddress,
    this.eventCity,
    this.participationCertificateTemplate,
    this.volunteerCertificateTemplate,
    this.volunteers,
    this.registeredParticipants,
    this.presentParticipants,
  });

  factory Event.fromJson(Map<String, dynamic> json) => Event(
        id: json["_id"],
        eventName: json["eventName"],
        eventDescription: json["eventDescription"],
        eventPoster: json["eventPoster"],
        eventStartDate: json["eventStartDate"] == null
            ? null
            : DateTime.parse(json["eventStartDate"]),
        eventStartTime: json["eventStartTime"],
        eventEndDate: json["eventEndDate"] == null
            ? null
            : DateTime.parse(json["eventEndDate"]),
        eventEndTime: json["eventEndTime"],
        collabOrganizationName: json["collabOrganizationName"],
        collabOrgEmail: json["collabOrgEmail"],
        eventAttachment: json["eventAttachment"] == null
            ? []
            : List<String>.from(json["eventAttachment"]!.map((x) => x)),
        organizerName: json["organizerName"],
        organizerEmail: json["organizerEmail"],
        organizerNumber: json["organizerNumber"],
        whatsAppLink: json["whatsAppLink"],
        noOfVolunteersNeeded: json["noOfVolunteersNeeded"],
        eventAddress: json["eventAddress"],
        eventCity: json["eventCity"],
        participationCertificateTemplate:
            json["participationCertificateTemplate"],
        volunteerCertificateTemplate: json["volunteerCertificateTemplate"],
        volunteerResponsibilities: json["volunteerResponsibilities"],
        volunteers: json["volunteers"] == null
            ? []
            : List<dynamic>.from(json["volunteers"]!.map((x) => x)),
        registeredParticipants: json["registeredParticipants"] == null
            ? []
            : List<dynamic>.from(json["registeredParticipants"]!.map((x) => x)),
        presentParticipants: json["presentParticipants"] == null
            ? []
            : List<dynamic>.from(json["presentParticipants"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "eventName": eventName,
        "eventDescription": eventDescription,
        "eventPoster": eventPoster,
        "eventStartDate": eventStartDate?.toIso8601String(),
        "eventStartTime": eventStartTime,
        "eventEndDate": eventEndDate?.toIso8601String(),
        "eventEndTime": eventEndTime,
        "collabOrganizationName": collabOrganizationName,
        "collabOrgEmail": collabOrgEmail,
        "eventAttachment": eventAttachment == null
            ? []
            : List<dynamic>.from(eventAttachment!.map((x) => x)),
        "organizerName": organizerName,
        "organizerEmail": organizerEmail,
        "organizerNumber": organizerNumber,
        "whatsAppLink": whatsAppLink,
        "noOfVolunteersNeeded": noOfVolunteersNeeded,
        "volunteersResposibilities": volunteerResponsibilities,
        "eventAddress": eventAddress,
        "eventCity": eventCity,
        "participationCertificateTemplate": participationCertificateTemplate,
        "volunteerCertificateTemplate": volunteerCertificateTemplate,
        "volunteers": volunteers == null
            ? []
            : List<dynamic>.from(volunteers!.map((x) => x)),
        "registeredParticipants": registeredParticipants == null
            ? []
            : List<dynamic>.from(registeredParticipants!.map((x) => x)),
        "presentParticipants": presentParticipants == null
            ? []
            : List<dynamic>.from(presentParticipants!.map((x) => x)),
      };
}
