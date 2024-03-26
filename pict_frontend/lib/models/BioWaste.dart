import 'dart:convert';

BioWaste bioWasteFromJson(String str) => BioWaste.fromJson(json.decode(str));

String bioWasteToJson(BioWaste data) => json.encode(data.toJson());

class BioWaste {
  String? id;
  String? title;
  String? description;
  String? type;
  List<String>? images;
  String? link;
  String? author;
  DateTime? datePublished;
  String? language;
  String? duration;
  DateTime? createdDate;

  BioWaste({
    this.id,
    this.title,
    this.description,
    this.type,
    this.images,
    this.link,
    this.author,
    this.datePublished,
    this.language,
    this.duration,
    this.createdDate,
  });

  factory BioWaste.fromJson(Map<String, dynamic> json) => BioWaste(
        id: json["_id"],
        title: json["title"],
        description: json["description"],
        type: json["type"],
        images: json["images"] == null
            ? []
            : List<String>.from(json["images"].map((x) => x)),
        link: json["link"],
        author: json["author"],
        datePublished: json["datePublished"] == null
            ? null
            : DateTime.parse(json["datePublished"]),
        language: json["language"],
        duration: json["duration"],
        createdDate: json["createdDate"] == null
            ? null
            : DateTime.parse(json["createdDate"]),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "title": title,
        "description": description,
        "type": type,
        "images":
            images == null ? [] : List<String>.from(images!.map((x) => x)),
        "link": link,
        "author": author,
        "datePublished":
            "${datePublished!.year.toString().padLeft(4, '0')}-${datePublished!.month.toString().padLeft(2, '0')}-${datePublished!.day.toString().padLeft(2, '0')}",
        "language": language,
        "duration": duration,
        "createdDate": createdDate?.toIso8601String(),
      };
}
