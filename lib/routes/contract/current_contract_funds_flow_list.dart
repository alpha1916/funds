import 'package:flutter/material.dart';
import 'package:funds/common/constants.dart';
import 'package:funds/common/utils.dart';
import 'package:funds/model/contract_data.dart';
import 'package:funds/network/http_request.dart';
import 'package:funds/routes/trade/stock_trade_main.dart';

class FlowData {
  double value = 1125.00;
  String title = '新增合约';
  String date = '2019-06-19 09:50:13';
  double usableMoney = 1125.00;
}

class CurrentContractFundsFlowList extends StatelessWidget {
  final String title;
  final dataList;
  CurrentContractFundsFlowList(this.title, this.dataList);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: ListView.builder(
          itemBuilder: (BuildContext context, int index){
          FlowData data = FlowData();
          return Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.symmetric(horizontal: a.px16, vertical: a.px10),
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(data.title, style: TextStyle(fontSize: a.px16),),
                        Text(data.value.toStringAsFixed(2), style: TextStyle(fontSize: a.px16, color: Utils.getProfitColor(data.value)),),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text('可用现金：${data.usableMoney}', style: TextStyle(fontSize: a.px16),),
                        Text(data.date, style: TextStyle(fontSize: a.px16))
                      ],
                    ),
                  ],
                ),
              ),
              Utils.buildSplitLine(),
            ],
          );
        },
      )
    );
  }
}
