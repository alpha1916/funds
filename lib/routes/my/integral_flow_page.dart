import 'package:flutter/material.dart';
import 'package:funds/model/account_data.dart';
import 'package:funds/common/constants.dart';
import 'package:funds/common/utils.dart';
import 'package:funds/network/user_request.dart';
import 'package:funds/common/widgets/custom_refresh_list_view.dart';
import 'package:funds/model/list_page_data.dart';

class IntegralFlowPage extends StatefulWidget {
  @override
  _IntegralFlowPageState createState() => _IntegralFlowPageState();
}

class _IntegralFlowPageState extends State<IntegralFlowPage> {
  ListPageDataHandler listPageDataHandler;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    listPageDataHandler = ListPageDataHandler(
        pageCount: 12,
        itemConverter: (data) => IntegralFlowData(data),
        requestDataHandler: (pageIndex, pageCount) async{
          var result = await UserRequest.getIntegralFlow(pageIndex, pageCount);
          return result.data;
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title:Text('积分流水'),
      ),
      body: CustomRefreshListView(
        indexedWidgetBuilder: _itemBuilder,
        refreshHandler: listPageDataHandler.refresh,
        loadMoreHandler: listPageDataHandler.loadMore,
      ),
    );
  }

  Widget _itemBuilder(BuildContext context, int index, dynamic data){
    String strValue = data.value > 0 ? '+${data.value}' : data.value.toString();
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(a.px16),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(data.title, style: TextStyle(fontSize: a.px15, color: Colors.black, fontWeight: FontWeight.w500),),
                  Text(strValue, style: TextStyle(fontSize: a.px15, color: Utils.getProfitColor(data.value), fontWeight: FontWeight.w500),),
                ],
              ),
              SizedBox(height: a.px6,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('积分余额：${data.remainingSum}', style: TextStyle(fontSize: a.px15)),
                  Text(data.date, style: TextStyle(fontSize: a.px15)),
                ],
              )
            ],
          ),
        ),
        Divider(height: 0, indent: a.px16),
      ],
    );
  }
}
