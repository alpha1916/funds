import 'package:flutter/material.dart';
import 'package:funds/model/account_data.dart';
import 'package:funds/common/constants.dart';
import 'package:funds/common/utils.dart';
import 'package:funds/network/user_request.dart';
import 'package:funds/routes/my/funds_detail_page.dart';

final type2title = ['', '公告消息', '活动精选', '系统消息'];
class MailPage extends StatelessWidget {
  final title;
  final List<MailData> dataList;
  MailPage(this.title, this.dataList);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:Text(title),
      ),
      body: ListView.builder(
        itemBuilder: (BuildContext context, int index){
//          print(dataList.length);
          int type = index + 1;
          print(dataList[index]?.type);
          MailData data;
          try {
            data = dataList.firstWhere((testData) => testData?.type == type);
          }catch(e) {

          }
          return _buildItem(index, data, type);
        },
        itemCount: dataList.length,
      ),
    );
  }

  _buildItem(index, data, type) {
    String imgPath = 'assets/mail/mail_type$type.png';
    return InkWell(
      child: Container(
        padding: EdgeInsets.fromLTRB(a.px16, a.px16, 0, 0),
        color: Colors.white,
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Image.asset(imgPath, width: a.px20,),
                SizedBox(width: a.px8),
                Text(type2title[type], style: TextStyle(fontSize: a.px17)),
                Utils.expanded(),
                Text(data?.date ?? ' ', style: TextStyle(fontSize: a.px14, color: Colors.black54)),
                SizedBox(width: a.px16,)
              ],
            ),
            SizedBox(height: a.px12),
            Container(
              margin: EdgeInsets.only(left: a.px28),
              alignment: Alignment.centerLeft,
              child: Text(data?.title ?? '暂无此类邮件', style: TextStyle(fontSize: a.px16, color: Colors.black54),),
            ),
            SizedBox(height: a.px16),
            Divider(height: 1),
          ],
        ),
      ),
      onTap: () => onSelectItem(index),
    );
  }

  onSelectItem(index) async{
    var data = dataList[index];
    if(data == null){
      alert('暂无此类邮件');
      return;
    }

    var result = await UserRequest.getMailData(data.type, 0, 10);
    if(result.success){
      Utils.navigateTo(MailListPage(type2title[data.type], result.data));
    }
  }
}

class MailListPage extends MailPage{
  MailListPage(title, dataList):super(title, dataList);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:Text(title),
      ),
      body: ListView.builder(
        itemBuilder: (BuildContext context, int index){
          MailData data = dataList[index];
          return _buildItem(index, data, data.type);
        },
        itemCount: dataList.length,
      ),
    );
  }

  @override
  onSelectItem(index) async{
    MailData data = dataList[index];
    if(data.type != MailType.system.index)
      Utils.navigateTo(MailDetailPage(data));
    else{
      await UserRequest.getUserInfo();
      Utils.navigateTo(FundsDetailPage());
    }
  }
}

class MailDetailPage extends StatelessWidget {
  final MailData data;
  MailDetailPage(this.data);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title:Text(type2title[data.type]),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            _buildTitleView(),
            Divider(height: a.px1, indent: a.px16),
            _buildContentView(),
          ],
        ),
      ),
    );
  }
  
  _buildTitleView(){
    return Container(
      padding: EdgeInsets.all(a.px16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Align(
            alignment: Alignment.centerLeft,
            child: Text(data.title, style: TextStyle(fontSize: a.px17)),
          ),
          SizedBox(height: a.px4,),
          Text(data.date, style: TextStyle(fontSize: a.px14, color: Colors.black45)),
        ],
      ),
    );
  }
  
  _buildContentView(){
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(a.px16),
        child: Text(data.content, style: TextStyle(fontSize: a.px17)),
      ),
    );
  }
}