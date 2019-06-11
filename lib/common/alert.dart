import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'utils.dart';
class CustomAlert {
  static BuildContext context;
  static init(ctx){
    context = ctx;
  }

  static show(tips) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Center(
          child: Text(
            tips,
            textAlign: TextAlign.center,
          )
        ),
        titleTextStyle: TextStyle(fontSize: 16, color: Colors.white),
        backgroundColor: Colors.black87,
      ),
      barrierDismissible: false
    );
    await Future.delayed(Duration(seconds: 1));
    Utils.navigatePop();
  }

  static show2(String title, String tips, String btnTitle){
    final borderColor = Colors.grey;
    showCupertinoDialog(
        context:context,
        builder:(BuildContext context){
          return new CupertinoAlertDialog(
            title: new Text(
              title,
            ),
            content: new Text(tips),
            actions: <Widget>[
              new Container(
                decoration: BoxDecoration(
                    border: Border(right:BorderSide(color: borderColor,width: 1.0),top:BorderSide(color: borderColor,width: 1.0))
                ),
                child: FlatButton(
                  child: new Text(btnTitle, style: TextStyle(color: Colors.blueAccent),),
                  onPressed:(){
                    Navigator.pop(context);
                  },
                ),
              ),
//            new Container(
//              decoration: BoxDecoration(
//                  border: Border(top:BorderSide(color: borderColor,width: 1.0))
//              ),
//              child: FlatButton(
//                child: new Text("取消"),
//                onPressed:(){
//                  Navigator.pop(context);
//                },
//              ),
//            )
            ],
          );
        }
    );
  }

  static Future<int> show3(String title, String tips, String btnTitle1, String btnTitle2){
    final borderColor = Colors.grey;
    return showCupertinoDialog(
        context:context,
        builder:(BuildContext context){
          return new CupertinoAlertDialog(
            title: new Text(
              title,
            ),
            content: new Text(tips),
            actions: <Widget>[
              new Container(
                decoration: BoxDecoration(
                    border: Border(right:BorderSide(color: borderColor,width: 1.0),top:BorderSide(color: borderColor,width: 1.0))
                ),
                child: FlatButton(
                  child: new Text(btnTitle1, style: TextStyle(color: Colors.blueAccent)),
                  onPressed:(){
                    Navigator.pop(context, 1);
                  },
                ),
              ),
              new Container(
                decoration: BoxDecoration(
                    border: Border(top:BorderSide(color: borderColor,width: 1.0))
                ),
                child: FlatButton(
                  child: new Text(btnTitle2, style: TextStyle(color: Colors.blueAccent)),
                  onPressed:(){
                    Navigator.pop(context, 2);
                  },
                ),
              )
            ],
          );
        }
    );
  }
}