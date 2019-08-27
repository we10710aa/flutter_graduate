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
      padding: const EdgeInsets.only(bottom: 8,left: 8,right: 8),
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
        child: Card(
          elevation: 8,
          child: Container(
            decoration: BoxDecoration(color: Color.fromRGBO(58, 66, 86,.9)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                CachedNetworkImage(
                  imageUrl: list[index].imgUrl,
                  placeholder: (context, url){
                    return Container(
                      width: 180,
                      height: 120,
                      child:Center(child: CircularProgressIndicator()));},
                  errorWidget: (context, url, error) => Icon(Icons.error),
                  fit: BoxFit.fill,
                  width: 180,
                  height: 120,
                ),
                SizedBox(
                  width: 8,
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        '中文名稱:' + list[index].chineseName,
                        style: TextStyle(color: Colors.white,fontSize: 20),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        '學名:' + list[index].name,
                        style: TextStyle(color: Colors.white),
                        overflow: TextOverflow.clip,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
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
