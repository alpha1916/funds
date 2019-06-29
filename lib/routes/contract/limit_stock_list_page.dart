import 'package:flutter/material.dart';
import 'package:funds/common/constants.dart';
import 'package:funds/model/stock_trade_data.dart';
import 'package:funds/common/utils.dart';

class LimitStockListPage extends StatelessWidget {
  final List<LimitStockData> dataList;
  LimitStockListPage(this.dataList);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:Text('今日限买股'),
      ),
      body:Container(
        color: CustomColors.background1,
        child: Column(
          children: <Widget>[
            SingleChildScrollView(
              child: Column(
                children: _buildItemList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _buildItemList() {
    List<Widget> list = [];
    int count = (dataList.length / 2).ceil();
    print(dataList.length);
    for(var i = 0; i < count; ++i){
      LimitStockData data1 = dataList[i * 2];
      LimitStockData data2;
      if((i * 2 + 1) < dataList.length)
        data2 = dataList[i * 2 + 1];
      list.add(_buildItem(data1, data2));
      if(i < (count - 1))
        list.add(Utils.buildSplitLine(margin: EdgeInsets.only(left: a.px25)));
    }
    list.add(Container(
      padding: EdgeInsets.fromLTRB(a.px16, a.px20, a.px16, a.px50),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text('平台不可甲乙基金、S、ST、*ST、S*ST及SST类股票', style: TextStyle(fontSize: a.px14),),
      )
    ));
    return list;
  }

  _buildItem(data1, data2){
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: a.px20, vertical: a.px16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          _buildStockItem(data1),
          _buildStockItem(data2),
        ],
      ),
    );
  }

  _buildStockItem(LimitStockData data){
    if(data == null)
      return Container();

    return Row(
      children: <Widget>[
        Container(
          width: a.px(76),
          child: Center(child:Text(data.name, style: TextStyle(fontSize: a.px16))),
        ),
        SizedBox(width: a.px20),
        Container(
          width: a.px(76),
          child: Center(child:Text(data.code, style: TextStyle(fontSize: a.px16))),
        ),
      ],
    );
  }
}
