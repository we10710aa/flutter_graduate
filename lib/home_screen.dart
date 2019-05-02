import 'dart:io';
import 'package:flutter_graduate/fish_collection.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';

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
  static final int WHAT_THE_FISH=0;

  Future pickImage() async{
    File image = await ImagePicker.pickImage(source: ImageSource.gallery);
    File cropped = await ImageCropper.cropImage(
        sourcePath: image.path
    );

    setState(() {
      _imageFile = cropped;
    });
  }

  _changePage(int index){
    setState(() {
      this._currentPage = index;
    });
  }


  @override
  Widget build(BuildContext context) {
    Widget _body;
    if(_currentPage == FISH_DATA){
      _body = FishCollection();
    }
    else{
      _body = Center(child: Text('hello'),);
    }
    return Scaffold(
      appBar: AppBar(title: Text('cropper'),),
      body:_body ,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentPage,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            title: Text('history')
          ),
          BottomNavigationBarItem(
            icon:Icon(Icons.search),
            title: Text('recog')
          )
        ],
        onTap: _changePage,
      ),

    );
  }

}