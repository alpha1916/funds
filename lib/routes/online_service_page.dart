import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:funds/common/constants.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class OnlineServicePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final String url = 'https://master.71baomu.com/code/app/10013223/1?header=none&device=${Global.platformName}';
    return WebviewScaffold(
      url: url,
      appBar: AppBar(
        title: Text('在线客服'),
        backgroundColor: CustomColors.background1,
      ),
      initialChild: Container(
        color: Colors.white,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SpinKitCircle(color: Colors.blueAccent, size: a.px36),
              SizedBox(height: a.px10,),
              Text('客服连接中', style: TextStyle(fontSize: a.px20)),
            ],
          )
        ),
      ),
//      withLocalStorage: true,
      hidden: true,
      resizeToAvoidBottomInset: true,
    );
  }
}
