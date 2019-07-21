import 'package:flutter/material.dart';
import 'package:funds/common/widgets/custom_refresh_list_view.dart';
import 'package:funds/model/list_page_data.dart';
import 'package:funds/network/user_request.dart';
import 'package:funds/model/account_data.dart';
import 'package:funds/common/constants.dart';

class RechargeDetailListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ListPageDataHandler listPageDataHandler = ListPageDataHandler(
        pageCount: 15,
        itemConverter: (data) => RechargeData(data),
        requestDataHandler: (pageIndex, pageCount) async{
          var result = await RechargeRequest.getDetailList(pageIndex, pageCount);
          return result.data;
        }
    );
    return Scaffold(
      appBar: AppBar(
        title:Text('充值记录'),
      ),
      body: CustomRefreshListView(
        indexedWidgetBuilder: _itemBuilder,
        refreshHandler: listPageDataHandler.refresh,
        loadMoreHandler: listPageDataHandler.loadMore,
      )
    );
  }

  Widget _itemBuilder(BuildContext context, int index, dynamic srcData){
    RechargeData data = srcData;
    Color stateColor = data.state != 2 ? CustomColors.red : null;
    return Container(
      color: Colors.white,
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(horizontal: a.px16, vertical: a.px10),
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('线下转账', style: TextStyle(fontSize: a.px15)),
                    Text('+${data.value.toStringAsFixed(2)}', style: TextStyle(fontSize: a.px15, color: CustomColors.red)),
                  ],
                ),
                SizedBox(height: a.px6,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(data.strState, style: TextStyle(fontSize: a.px15, color: stateColor)),
                    Text(data.date, style: TextStyle(fontSize: a.px15)),
                  ],
                )
              ],
            ),
          ),
          Divider(height: 0, indent: a.px16),
        ],
      ),
    );
  }
}
