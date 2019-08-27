import 'package:flutter/material.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path/path.dart';

class HistoryScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HistoryScreenState();
  }
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<String> list;
  Directory directory;

  Future<List<String>> getImageList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> recog_list = await prefs.getStringList("recognition_history");
    await getDirectory();
    return recog_list;
  }

  Future getDirectory() async {
    this.directory = await getApplicationDocumentsDirectory();
  }

  Widget _listItemBuilder(BuildContext context, int index) {
    return Padding(
      padding: const EdgeInsets.only(top: 8,left: 8,right: 8),
      child: Card(
        elevation: 8,
        child: Container(
          decoration: BoxDecoration(color: Color.fromRGBO(58, 66, 86,.9)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: 150,
                height:100,
                child: Image.file(
                  File(join(this.directory.path, this.list[index])),
                  fit: BoxFit.fill,
                ),
              ),
              SizedBox(
                width: 8,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    '時間: '+this.list[index].substring(0,this.list[index].length-4),textAlign: TextAlign.left,
                    style: TextStyle(color: Colors.white,fontSize: 16),
                  ),
                  Text(
                    '辨識結果: ',textAlign: TextAlign.left,
                    style:TextStyle(color: Colors.white,fontSize: 15),
                  )

                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<String>>(
      future: getImageList(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          this.list = snapshot.data;
          return ListView.builder(
            itemBuilder: _listItemBuilder,
            itemCount: snapshot.data.length,
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
