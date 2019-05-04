import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_graduate/fish_json_converter.dart';
import 'package:webview_flutter/webview_flutter.dart';

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
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder:(context)=>Route(BASE_URL + list[index].id)));
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              width: 160,
              height: 100,
              child: CachedNetworkImage(
                imageUrl: list[index].imgUrl,
                placeholder: (context,url)=>CircularProgressIndicator(),
                errorWidget: (context,url,error)=>Icon(Icons.error),
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(width: 8,),
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

class Route extends StatelessWidget{
  String _url;
  Route(String url){
    this._url = url;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
          padding: const EdgeInsets.only(top:24.0),
          child: WebView(initialUrl:_url),
        )
    );
  }

}