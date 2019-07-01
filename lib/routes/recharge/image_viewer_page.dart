import 'package:flutter/material.dart';
import 'package:funds/common/utils.dart';

class ImageViewerPage extends StatelessWidget {
  final String path;
//  final bool deletable;
  ImageViewerPage(this.path);//, this.deletable);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:Text('凭证预览'),
        actions: <Widget>[
          FlatButton(
            child: const Text('删除'),
            onPressed: (){
              Utils.navigatePop(true);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Image.asset(path, fit: BoxFit.cover),
      ),
    );
  }
}
