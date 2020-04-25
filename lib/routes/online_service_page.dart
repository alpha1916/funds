import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:funds/common/constants.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class OnlineServicePageAndroid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
//    final String url = 'https://master.71baomu.com/code/app/10013223/1?header=none&device=${Global.platformName}';
    final String url = 'https://tb.53kf.com/code/client/90e0e56c2ab868d23d7201d5ec27a07c2/1?header=none&device=${Global.platformName}';
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

//class OnlineServicePage extends StatefulWidget {
//  @override
//  _OnlineServicePageState createState() => _OnlineServicePageState();
//}
//
//class _OnlineServicePageState extends State<OnlineServicePage> {
//  String title = '正在连接客服。。';
//
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      appBar: AppBar(
//        title:Text(title),
//      ),
//      body: _buildWebView(),
//      resizeToAvoidBottomPadding: false,
//    );
//  }
//
//  Widget _buildWebView() {
//    Set<JavascriptChannel> javascriptChannels = Set();
//    javascriptChannels.add(JavascriptChannel(name: 'back', onMessageReceived: (JavascriptMessage msg){
//      if(mounted)
//        Utils.navigatePop();
//    }));
////    final String url = 'https://master.71baomu.com/code/app/10013223/1?header=none&device=${Global.platformName}';
//    final String url = 'https://tb.53kf.com/code/client/90e0e56c2ab868d23d7201d5ec27a07c2/1?header=none&device=${Global.platformName}';
//    return WebView(
//      initialUrl: url,
//      javascriptMode: JavascriptMode.unrestricted,
//      javascriptChannels: javascriptChannels,
//      onPageFinished: (String url){
//        print('loaded');
//        setState(() {
//          title = '在线客服';
//        });
//      },
//    );
//  }
//
////  _buildLoadingView() {
////    return Container(
////      color: Colors.white,
////      child: Center(
////        child: Column(
////          mainAxisAlignment: MainAxisAlignment.center,
////          children: <Widget>[
////            SpinKitCircle(color: Colors.blueAccent, size: a.px36),
////            SizedBox(height: a.px10,),
////            Text('客服连接中', style: TextStyle(fontSize: a.px20)),
////          ],
////        ),
////      ),
////    );
////  }
//}