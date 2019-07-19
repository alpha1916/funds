import 'package:flutter/material.dart';
import 'package:funds/common/constants.dart';
import 'package:funds/common/utils.dart';
import 'package:funds/routes/webview_page.dart';

class HelpPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:Text('帮助与客服'),
      ),
      body: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(vertical: a.px20),
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                _buildHelpItem(CustomIcons.helpBasic, '基础介绍', _showBasicIntro),
                _buildHelpItem(CustomIcons.helpTrade, '股票交易', _showTrade),
                _buildHelpItem(CustomIcons.helpCash, '充值提现', _showCash),
              ],
            )
          ),
          SizedBox(height: a.px12,),
          Container(
            color: Colors.white,
            child: Column(
              children: <Widget>[
                _buildServiceItem(icon: CustomIcons.onlineService, title: '在线客服', onPressed: Utils.openOnlineService),
                Divider(height: 0, indent: a.px16),
                _buildServiceItem(icon: CustomIcons.onlineService, title: '电话客服', onPressed: Utils.callService, trailingTips: '交易日 8:30-18:00'),
              ],
            ),
          ),
        ],
      )
    );
  }

  _buildHelpItem(icon, title, onPressed){
    return InkWell(
      child: Column(
        children: <Widget>[
          Image.asset(icon, width: a.px(64)),
          SizedBox(height: a.px10),
          Text(title, style: TextStyle(fontSize: a.px16, color: Colors.black, fontWeight: FontWeight.w400)),
        ],
      ),
      onTap: onPressed,
    );
  }

  _buildServiceItem({icon, title, onPressed, trailingTips}){
    return InkWell(
      child: Container(
        padding: EdgeInsets.all(a.px16),
        child: Row(
          children: <Widget>[
            Image.asset(icon, width: a.px20),
            SizedBox(width: a.px12,),
            Text(title, style: TextStyle(fontSize: a.px17, color: Colors.black, fontWeight: FontWeight.w400),),
            Utils.expanded(),
            trailingTips != null ? Text('$trailingTips  ', style: TextStyle(fontSize: a.px14, color: Colors.grey)) : Container(),
            Utils.buildForwardIcon(),
          ],
        ),
      ),
      onTap: onPressed,
    );
  }

  _openHelpPage(type, title) {
    String url = Global.host + 'api/v1/help?type=$type';
    Utils.navigateTo(WebViewPage(title: title, url: url));
  }

  _showBasicIntro(){
    _openHelpPage(1, '基础介绍');
  }

  _showTrade() {
    _openHelpPage(2, '股票交易');
  }

  _showCash() {
    _openHelpPage(3, '充值提现');
  }
}
