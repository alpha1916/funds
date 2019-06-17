import 'package:flutter/material.dart';
import 'package:funds/common/constants.dart';
import 'package:funds/common/utils.dart';
import 'package:funds/model/contract_data.dart';

class TradeFlowPage extends StatelessWidget {
  final List<TradeFlowData> dataList;
  TradeFlowPage(this.dataList);
  @override
  Widget build(BuildContext context) {
    final realWidth = MediaQuery.of(context).size.width;
    double leftPadding = a.px10;
    double rightPadding = 0;
    double itemWidth = realWidth - leftPadding - rightPadding;
    List<double> sizeList = _sizeListRate.map((rate) => itemWidth * rate).toList();
    return Scaffold(
      appBar: AppBar(
          title: Text('交易流水')
      ),
      body: Container(
          color: Colors.white,
          child: Column(
            children: <Widget>[
              _buildTitleList(sizeList, leftPadding, rightPadding),
              Container(height: a.px1, color: Colors.black12),
              Expanded(
                child:ListView.builder(
                  itemBuilder: (BuildContext context, int index){
                    return _buildStockItem(index, sizeList, leftPadding, rightPadding);
                  },
                  itemCount: dataList.length,
                ),
              ),
            ],
          )
      ),
    );
  }
  final _titles = ['名称/代码', '价格/数量', '状态/类型', '成交时间'];
  final List<double> _sizeListRate = [0.25, 0.25, 0.25, 0.25];

  _buildTitleList(sizeList, leftPadding, rightPadding) {
    buildText(title, alignment){
      Widget text = Text(title, style: TextStyle(fontSize: a.px15, color: Colors.black, fontWeight: FontWeight.w500));
      text = Align(
        alignment: alignment,
        child: Text(title, style: TextStyle(fontSize: a.px15, color: Colors.black, fontWeight: FontWeight.w500)),
      );
      return text;
    }
//    Text text = Text(title, style: TextStyle(fontSize: a.px15, color: Colors.black, fontWeight: FontWeight.w500));
    return Container(
      padding: EdgeInsets.only(left: leftPadding, right: rightPadding, top: a.px8, bottom: a.px8),
      child:Row(
        children: _titles.map((title){
          final int idx = _titles.indexOf(title);
          return Container(
            padding: EdgeInsets.only(right: leftPadding),
            width: sizeList[idx],
            child: buildText(title, idx < 3 ? FractionalOffset.topLeft : FractionalOffset.topRight),
          );
        }).toList(),
      ),
    );
  }

  _buildStockItem(index, sizeList, leftPadding, rightPadding) {
    TradeFlowData data = dataList[index];
    double fontSize = a.px15;
    return Container(
      color: Colors.transparent,
//      margin: EdgeInsets.only(right: rightPadding, top: a.px8, bottom: a.px8),
      child: Column(
        children: <Widget>[
          SizedBox(height: a.px10,),
          Row(
            children: <Widget>[
              //名称/代码
              Container(
                padding: EdgeInsets.only(left: leftPadding),
                width: sizeList[0],
                child: Column(
                  children: <Widget>[
                    Align(
                      alignment: FractionalOffset.topLeft,
                      child: Text(data.title, style: TextStyle(fontSize: fontSize),),
                    ),
                    Align(
                      alignment: FractionalOffset.topLeft,
                      child: Text(data.code.toString(), style: TextStyle(fontSize: fontSize),),
                    ),
                  ],
                ),
              ),
              //价格/数量
              Container(
                padding: EdgeInsets.only(left: leftPadding),
                width: sizeList[1],
                child: Column(
                  children: <Widget>[
                    Align(
                      alignment: FractionalOffset.topLeft,
                      child: Text(data.price.toStringAsFixed(2), style: TextStyle(fontSize: fontSize),),
                    ),
                    Align(
                      alignment: FractionalOffset.topLeft,
                      child: Text(Utils.getTrisectionInt(data.count.toString()), style: TextStyle(fontSize: fontSize)),
                    ),
                  ],
                ),
              ),
              //状态/类型
              Container(
                padding: EdgeInsets.only(left: leftPadding, right: a.px5),
                width: sizeList[2],
                child: Column(
                  children: <Widget>[
                    Align(
                      alignment: FractionalOffset.topLeft,
                      child: Text(data.strState, style: TextStyle(fontSize: fontSize),),
                    ),
                    Align(
                      alignment: FractionalOffset.topLeft,
                      child: Text(data.strType, style: TextStyle(fontSize: fontSize, color: Utils.getEntrustTypeColor(data.type))),
                    ),
                  ],
                ),
              ),
              //成交时间
              Container(
                padding: EdgeInsets.only(left: leftPadding, right: a.px5),
                width: sizeList[3],
                child: Column(
                  children: <Widget>[
                    Align(
                      alignment: FractionalOffset.topRight,
                      child: Text(data.strDay, style: TextStyle(fontSize: fontSize),),
                    ),
                    Align(
                      alignment: FractionalOffset.topRight,
                      child: Text(data.strTime, style: TextStyle(fontSize: fontSize)),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: a.px10),
          Container(height: a.px1, color: Colors.black12),
        ],
      ),
    );
  }
}