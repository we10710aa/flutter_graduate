import 'dart:io';
import 'package:flutter_graduate/fish_collection.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:flutter_graduate/history_screen.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MyHomeScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _HomeScreenState();
  }

}

class _HomeScreenState extends State<MyHomeScreen>{
  File _imageFile;
  int _currentPage=1;
  static final int FISH_DATA=0;
  static final int WHAT_THE_FISH=1;
  static final int HISTORY=2;

  Future pickImage(BuildContext context) async{
    File image = await ImagePicker.pickImage(source: ImageSource.gallery);
    File cropped = await ImageCropper.cropImage(
        sourcePath: image.path
    );
    storeImageToDisk(cropped);
    setState(() {
      _imageFile = cropped;
    });
    showDialog(context: context,builder: resultDialogBuilder);
  }
  Future storeImageToDisk(File imageFile) async{
    String nowString =DateFormat("y-M-d-H:m:s").format(DateTime.now());
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> recog_list = prefs.getStringList("recognition_history");
    if(recog_list==null){
      recog_list= new List<String>();
    }
    recog_list.insert(0,nowString+'.png');
    await prefs.setStringList("recognition_history", recog_list);

    Directory directory = await getApplicationDocumentsDirectory();

    File storePath = File(join(directory.path,nowString+'.png'));
    storePath.writeAsBytesSync(imageFile.readAsBytesSync());
  }

  _changePage(int index){
    if(this._currentPage==index){
      return;
    }
    setState(() {
      this._currentPage = index;
    });
  }

  Widget resultDialogBuilder(BuildContext context){
    return SimpleDialog(
      contentPadding: EdgeInsets.zero,
      children: <Widget>[
        Image.network('http://fishdb.sinica.edu.tw/chi/spe_picture/dpi300/a750-07.jpg'),
        Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                '辨識結果: 多鱗四指馬鮁',
                style: Theme.of(context).textTheme.title,
              ),
              Text('學名：Eleutheronema rhadinum'),
              RaisedButton(
                child: Text('閱讀更多'),
                onPressed:(){},
              )
            ],
          ),
        )
      ],
    );

  }


  @override
  Widget build(BuildContext context) {
    Widget _body;
    Text _titleText;
    if(_currentPage == FISH_DATA){
      _body = FishCollectionWidget();
      _titleText = Text('魚類圖鑑');
    }
    else if(_currentPage == WHAT_THE_FISH){
      _body = Center(
        child: _body = Material(
          elevation: 4.0,
          shape: CircleBorder(),
          color: Colors.transparent,
          child: Ink.image(
            image: AssetImage('assets/peg.png'),
            width: 120,
            height: 120,
            child: InkWell(
              onTap: ()=>pickImage(context),
              child: null,
            ),
          )
        ),
      );
      _titleText = Text('開始辨識');
    }
    else if(_currentPage ==HISTORY){
      _body= Center(child: HistoryScreen());
      _titleText = Text('辨識歷史');
    }
    return Scaffold(
      appBar: AppBar(title: _titleText,),
      body:_body ,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentPage,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            title: Text('Collection')
          ),
          BottomNavigationBarItem(
            icon:Icon(Icons.remove_red_eye),
            title: Text('Recognize')
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark),
            title: Text('history')
          )
        ],
        onTap: _changePage,
      ),

    );
  }

}