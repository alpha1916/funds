import 'package:flutter/material.dart';
import 'package:funds/model/account_data.dart';
import 'package:funds/common/constants.dart';
import 'package:funds/common/utils.dart';
import 'package:funds/network/user_request.dart';

import 'mail_list_page.dart';

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
          //屏蔽其他邮件，只显示系统消息
          if(index < 2)
            return Container();

          int type = index + 1;
          MailData data = dataList[index];
          return _buildItem(index, data, type);
        },
        itemCount: dataList.length,
      ),
    );
  }

  _buildItem(int index, MailData data, int type) {
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

//    var result = await UserRequest.getMail(data.type, 0, 10);
//    if(result.success){
//      Utils.navigateTo(MailListPage(type2title[data.type], result.data));
//    }

    Utils.navigateTo(MailListPage(data.type));
  }
}
