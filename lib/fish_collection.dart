import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_graduate/fish_json_converter.dart';
import 'package:flutter_graduate/web_page.dart';
import 'package:url_launcher/url_launcher.dart';

class FishCollectionWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _FishCollectionWidgetState();
  }
}

class _FishCollectionWidgetState extends State<FishCollectionWidget> {
  FishCollection _fishCollection;
  static final BASE_URL = 'http://fishdb.sinica.edu.tw/mobi/species.php?id=';

  Widget _listItemBuilder(BuildContext context, int index) {
    List<Fish> list = _fishCollection.fishs;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 8),
      child: GestureDetector(
        onTap: () async{
          //This is a workaround because flutter webview doesn't seen to work with http
          String url = BASE_URL + list[index].id;
          if (Platform.isAndroid) {
            Navigator.push(context, MaterialPageRoute(builder: (context) => WebViewPage(url)));
          }
          else if(Platform.isIOS){
            if(await canLaunch(url)){
              await launch(url);
            }
          }
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            CachedNetworkImage(
              imageUrl: list[index].imgUrl,
              placeholder: (context, url){
                return Container(
                  width: 160,
                  height: 100,
                  child:Center(child: CircularProgressIndicator()));},
              errorWidget: (context, url, error) => Icon(Icons.error),
              fit: BoxFit.cover,
              width: 160,
              height: 100,
            ),
            SizedBox(
              width: 8,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('中文名稱:' + list[index].chineseName),
                Text('學名:' + list[index].name),
              ],
            ),
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
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
