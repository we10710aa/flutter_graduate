import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';

class FishCollection extends StatelessWidget{
  Map<String,dynamic> fish;

  Widget _listItemBuilder(BuildContext context,int index){
    print(fish['data'].runtimeType);
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: GestureDetector(
        onTap: (){},
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('id:' +fish['data'][index]["id"]),
            Text('name'+fish['data'][index]["name"]),
          ],
        ),
      ),
    );
  }

  Future<Map<String,dynamic>> loadFishJson() async{
    String readString = await rootBundle.loadString('assets/fish.json');
    fish = await json.decode(readString);
    return json.decode(readString);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String,dynamic>>(
      future: loadFishJson(),
      builder: (context,snapshot){
        return ListView.builder(
          itemBuilder: _listItemBuilder,
        );
      },
    );
  }

}