import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';

class FishCollectionWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _FishCollectionWidgetState();
  }
}

class _FishCollectionWidgetState extends State<FishCollectionWidget> {
  FishCollection _fishCollection;

  Widget _listItemBuilder(BuildContext context, int index) {
    List<Fish> list = _fishCollection.fishs;
    return Padding(
      padding: const EdgeInsets.only(bottom: 16, left: 8),
      child: GestureDetector(
        onTap: () {},
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('id:' + list[index].id),
            Text('name:' + list[index].name),
            Center(
              child: Image.network(list[index].imgUrl),
            )
          ],
        ),
      ),
    );
  }

  Future<FishCollection> loadFishJson() async {
    String readString = await rootBundle.loadString('assets/fish.json');
    FishCollection collection = fishCollectionFromJson(readString);
    return collection;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<FishCollection>(
      future: loadFishJson(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          this._fishCollection = snapshot.data;
          return ListView.builder(
            itemBuilder: _listItemBuilder,
          );
        }
        else{
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}

// To parse this JSON data, do
//
//     final fishCollection = fishCollectionFromJson(jsonString);

FishCollection fishCollectionFromJson(String str) =>
    FishCollection.fromJson(json.decode(str));

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

  factory FishCollection.fromJson(Map<String, dynamic> json) =>
      new FishCollection(
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

  Fish({
    this.family,
    this.genus,
    this.spcific,
    this.name,
    this.id,
    this.imgUrl,
  });

  factory Fish.fromJson(Map<String, dynamic> json) => new Fish(
        family: json["family"],
        genus: json["genus"],
        spcific: json["spcific"],
        name: json["name"],
        id: json["id"],
        imgUrl: json["imgUrl"],
      );

  Map<String, dynamic> toJson() => {
        "family": family,
        "genus": genus,
        "spcific": spcific,
        "name": name,
        "id": id,
        "imgUrl": imgUrl,
      };
}
