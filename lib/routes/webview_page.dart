import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:funds/common/constants.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class WebViewPage extends StatelessWidget {
  final String title;
  final String url;
  final Map<String, String> headers;
  WebViewPage({this.title, this.url, this.headers});
  @override
  Widget build(BuildContext context) {
    return WebviewScaffold(
      url: url,
      headers: headers,
      appBar: AppBar(
        title: Text(title),
        backgroundColor: CustomColors.background1,
      ),
      initialChild: Container(
        color: Colors.white,
        child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SpinKitCircle(color: Colors.blueGrey, size: a.px36),
                SizedBox(height: a.px10,),
                Text('加载中', style: TextStyle(fontSize: a.px20)),
              ],
            )
        ),
      ),
      hidden: true,
    );
  }
}