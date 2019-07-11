import 'package:flutter/material.dart';
import 'package:funds/common/constants.dart';
import 'package:funds/common/utils.dart';
import 'concern_wx_page.dart';
import 'suggest_page.dart';

class AboutPage extends StatelessWidget {
  final itemDivider = Divider(height: 0, indent: a.px16,);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:Text('关于我们'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(top: a.px30, bottom: a.px20),
              color: Color.fromARGB(255, 97, 97, 111),
              width: double.infinity,
              child: Column(
                children: <Widget>[
                  Image.asset(CustomIcons.logo, width: a.px(60), fit: BoxFit.fill),
                  SizedBox(height: a.px20,),
                  Text('股票配资神器', style: TextStyle(fontSize: a.px18, color: Colors.white, fontWeight: FontWeight.w500),),
                ],
              )
            ),
            Container(
              color: Colors.white,
              child: Column(
                children: <Widget>[
                  _buildItem(icon: CustomIcons.companyIntro, title: '公司介绍', onPressed: _showIntro),
                  itemDivider,
                  _buildItem(icon: CustomIcons.media, title: '媒体报道', onPressed: _showMedia),
                  itemDivider,
                  _buildItem(icon: CustomIcons.concern, title: '关注微信', onPressed: _showConcernWx),
                  itemDivider,
                  _buildItem(icon: CustomIcons.share, title: '分享${Global.appName}', onPressed: _share),
                ],
              ),
            ),
            SizedBox(height: a.px12),
            Container(
              color: Colors.white,
              child: Column(
                children: <Widget>[
                  _buildItem(icon: CustomIcons.suggest, title: '投诉建议', onPressed: _suggest),
                  itemDivider,
                  _buildItem(icon: CustomIcons.serviceItems, title: '服务条款', onPressed: _showServiceItems),
                  itemDivider,
                  _buildItem(icon: CustomIcons.version, title: '当前版本', onPressed: _checkVersion, trailingTips: 'v${Global.version}'),
                ],
              ),
            ),
          ],
        ),
      )
    );
  }

  _buildItem({icon, title, onPressed, trailingTips}){
    return InkWell(
      child: Container(
        padding: EdgeInsets.all(a.px16),
        child: Row(
          children: <Widget>[
            Image.asset(icon, width: a.px20),
            SizedBox(width: a.px12,),
            Text(title, style: TextStyle(fontSize: a.px17, color: Colors.black, fontWeight: FontWeight.w400),),
            Utils.expanded(),
            trailingTips != null ? Text('$trailingTips  ', style: TextStyle(fontSize: a.px17, color: Colors.grey)) : Container(),
            Utils.buildForwardIcon(),
          ],
        ),
      ),
      onTap: onPressed,
    );
  }

  _showIntro() {}
  _showMedia() {}
  _showConcernWx() {
    Utils.navigateTo(ConcernWXPage());
  }
  _share() {}
  _suggest() {
    Utils.navigateTo(SuggestPage());
  }
  _showServiceItems() {}
  _checkVersion() {
    alert2('提示', '当前已是最新版本', '知道了');
  }
}