import 'package:flutter/material.dart';
import 'package:funds/model/account_data.dart';
import 'package:funds/common/constants.dart';
import 'package:funds/common/utils.dart';
import 'package:funds/network/user_request.dart';
import 'package:funds/network/contract_request.dart';
import 'package:funds/routes/my/funds_detail_page.dart';

import 'package:funds/common/widgets/custom_refresh_list_view.dart';
import 'package:funds/model/list_page_data.dart';
import 'mail_page.dart';
import 'package:funds/routes/my/coupons_page.dart';
import 'package:funds/routes/contract/current_contract_detail.dart';
import 'package:funds/pages/trade/history_contract_detail.dart';

enum SystemMailType {
  none,
  contract,
  cash,
  coupon,
}

class MailListPage extends StatelessWidget{
  final int type;
  ListPageDataHandler listPageDataHandler;
  MailListPage(this.type){
    listPageDataHandler = ListPageDataHandler(
      itemConverter: (data) => MailData(data),
      requestDataHandler: (pageIndex, pageCount) async{
        var result = await UserRequest.getMailList(type, pageIndex, pageCount);
        return result.data;
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:Text(type2title[type]),
      ),
      body: CustomRefreshListView(
        indexedWidgetBuilder: _itemBuilder,
        refreshHandler: listPageDataHandler.refresh,
        loadMoreHandler: listPageDataHandler.loadMore,
      ),
    );
  }

  onSelectItem(MailData data) async{
    if(data.type != MailType.system.index)
      Utils.navigateTo(MailDetailPage(data));
    else{
      if(data.subtype == SystemMailType.contract.index){
        ResultData result = await ContractRequest.getContractDetail(data.extra);
        if(result.success){
          ContractData data = result.data;
          if(data.ongoing){
            Utils.navigateTo(CurrentContractDetail(data));
          }else{
            Utils.navigateTo(HistoryContractDetail(data));
          }
        }
      }else if(data.subtype == SystemMailType.cash.index){
        await UserRequest.getUserInfo();
        Utils.navigateTo(FundsDetailPage());
      }else if(data.subtype == SystemMailType.coupon.index){
        Utils.navigateTo(CouponsPage());
      }else{
        alert('未处理系统邮件类型');
      }
    }
  }

  Widget _itemBuilder(BuildContext context, int index, srcData) {
    MailData data = srcData;
    String imgPath = 'assets/mail/mail_type${data.type}.png';
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
              child: Text(data?.title ?? '', style: TextStyle(fontSize: a.px16, color: Colors.black54),),
            ),
            SizedBox(height: a.px16),
            Divider(height: 1),
          ],
        ),
      ),
      onTap: () => onSelectItem(data),
    );
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