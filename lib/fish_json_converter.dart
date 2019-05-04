// To parse this JSON data, do
//
//     final fishCollection = fishCollectionFromJson(jsonString);
import 'dart:convert';

FishCollection fishCollectionFromJson(String str) => FishCollection.fromJson(json.decode(str));

String fishCollectionToJson(FishCollection data) => json.encode(data.toJson());

class FishCollection {
  String name;
  String format;
  List<Fish> fishs;

  FishCollection({
    this.name,
    this.format,
    this.fishs,
  });

  factory FishCollection.fromJson(Map<String, dynamic> json) => new FishCollection(
    name: json["name"],
    format: json["format"],
    fishs: new List<Fish>.from(json["fishs"].map((x) => Fish.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "format": format,
    "fishs": new List<dynamic>.from(fishs.map((x) => x.toJson())),
  };
}

class Fish {
  String family;
  String genus;
  String spcific;
  String name;
  String id;
  String imgUrl;
  String chineseName;

  Fish({
    this.family,
    this.genus,
    this.spcific,
    this.name,
    this.id,
    this.imgUrl,
    this.chineseName,
  });

  factory Fish.fromJson(Map<String, dynamic> json) => new Fish(
    family: json["family"],
    genus: json["genus"],
    spcific: json["spcific"],
    name: json["name"],
    id: json["id"],
    imgUrl: json["imgUrl"],
    chineseName: json["chineseName"],
  );

  Map<String, dynamic> toJson() => {
    "family": family,
    "genus": genus,
    "spcific": spcific,
    "name": name,
    "id": id,
    "imgUrl": imgUrl,
    "chineseName": chineseName,
  };
}
