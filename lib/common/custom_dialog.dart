import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'utils.dart';
import 'package:funds/common/constants.dart';

class CustomDialog {
  static BuildContext context;

  static init(ctx) {
    context = ctx;
  }

  static show(tips, [duration = 1000]) async {
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
        barrierDismissible: false);
    await Future.delayed(Duration(milliseconds: duration));
    Utils.navigatePop();
  }

  static show2(String title, String tips, String btnTitle) {
    showCupertinoDialog(
        context: context,
        builder: (BuildContext context) {
          return new CupertinoAlertDialog(
            title: new Text(
              title,
            ),
            content: new Text(tips),
            actions: <Widget>[
              _buildButton(btnTitle, Colors.blueAccent),
            ],
          );
        });
  }

  static Future<int> show3(String title, String tips, String btnTitle1, String btnTitle2) {
    Text titleText;
    if(title != null)
      titleText = Text(title);
    return showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return new CupertinoAlertDialog(
          title: titleText,
          content: new Text(tips),
          actions: <Widget>[
            _buildButton(btnTitle1, Colors.blueAccent, 1),
            _buildButton(btnTitle2, Colors.blueAccent, 2),
          ],
        );
      }
    );
  }

  static _buildButton(title, [color, value]) {
    return Container(
      decoration: BoxDecoration(
          border: Border(
        top: BorderSide(color: Colors.grey, width: 0.5),
        right: BorderSide(color: Colors.grey, width: 0.5),
      )),
      child: FlatButton(
        child: new Text(title, style: TextStyle(color: color)),
        onPressed: () {
          Navigator.pop(context, value);
        },
      ),
    );
  }

  static Future<dynamic> showCustomDialog(Widget dialog) async {
    return showDialog(
        context: context,
        builder: (context) {
          return Center(
            child: Material(
              borderRadius: BorderRadius.all(Radius.circular(a.px12)),
              child: dialog,
            )
          );
        },
        barrierDismissible: true
    );
  }
}
