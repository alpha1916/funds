import 'package:flutter/material.dart';
import 'package:funds/common/constants.dart';
import 'package:funds/common/utils.dart';
import 'package:funds/model/contract_data.dart';

//import 'package:funds/common/widgets/custom_data_table.dart';

class TradeFlowPage extends StatelessWidget {
  final List<TradeFlowData> dataList;
  final String title;
  final int type;
  TradeFlowPage(this.title, this.type, this.dataList);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(title)
      ),
      body: Container(
          color: Colors.white,
          child: Column(
            children: <Widget>[
              _buildTitleColumn(),
              Divider(height: a.px1),
              _buildDataRows(),
            ],
          )
      ),
    );
  }

  _buildDataRows(){
    return Expanded(
      child:ListView.builder(
        itemBuilder: (BuildContext context, int index){
          TradeFlowData data = dataList[index];
          return _buildStockItem(data);
        },
        itemCount: dataList.length,
      ),
    );
  }

  _getStateText() {
    String text = '';
    if(type == StateType.deal)
      text = '成交';
    else if(type == StateType.noDeal)
      text = '委托';

    return text;
  }

  final List<int> _rowFlex = [1, 1, 1, 1];

  _buildTitleColumn() {
    final _titles = ['名称/代码', '价格/数量', '状态/类型', '${_getStateText()}时间'];
    return Container(
      padding: EdgeInsets.symmetric(horizontal: a.px10, vertical: a.px8),
      child:Row(
        children: _titles.map((title){
          final int idx = _titles.indexOf(title);
          TextAlign align = idx < 3 ? TextAlign.left : TextAlign.right;
          return Expanded(
              flex: _rowFlex[idx],
              child: Text(title, style: TextStyle(fontSize: a.px15, color: Colors.black, fontWeight: FontWeight.w500), textAlign: align),
          );
        }).toList(),
      ),
    );
  }

  _buildRow({flex, text1, text2, alignment = FractionalOffset.centerLeft, color}){
    return Expanded(
      flex : flex,
      child: Column(
        children: <Widget>[
          Align(
            alignment: alignment,
            child: Text(text1, style: TextStyle(fontSize: a.px15, fontWeight: FontWeight.w500),),
          ),
          SizedBox(height: a.px6,),
          Align(
            alignment: alignment,
            child: Text(text2, style: TextStyle(fontSize: a.px15, color: color, fontWeight: FontWeight.w500),),
          ),
        ],
      ),
    );
  }

  _buildStockItem(TradeFlowData data) {
    return Container(
      color: Colors.transparent,
      child: Column(
        children: <Widget>[
          SizedBox(height: a.px10,),
          Row(
            children: <Widget>[
              SizedBox(width: a.px10,),
              //名称/代码
              _buildRow(flex: _rowFlex[0], text1: data.title, text2: data.code),
              //价格/数量
              _buildRow(flex: _rowFlex[1], text1: Utils.getTrisection(data.price), text2: Utils.getTrisectionInt(data.count.toString()), color: Utils.getEntrustTypeColor(data.type)),
              //状态/类型
              _buildRow(flex: _rowFlex[2], text1: data.strState, text2: data.strType),
              //成交时间
              _buildRow(flex: _rowFlex[3], text1: data.strDay, text2: data.strTime, alignment: FractionalOffset.centerRight),
              SizedBox(width: a.px10,),
            ],
          ),
          SizedBox(height: a.px10),
          Divider(height: a.px1),
        ],
      ),
    );
  }
}

//class TradeFlowPage extends StatelessWidget {
//  final List<TradeFlowData> dataList;
//  final String title;
//  final int type;
//
//  TradeFlowPage(this.title, this.type, this.dataList);
//  _getStateText() {
//    String text = '';
//    if(type == StateType.deal)
//      text = '成交';
//    else if(type == StateType.noDeal)
//      text = '委托';
//
//    return text;
//  }
//  @override
//  Widget build(BuildContext context) {
//    final _titles = ['名称/代码', '价格/数量', '状态/类型', '${_getStateText()}时间'];
//    return Scaffold(
//      appBar: AppBar(
//          title: Text(title)
//      ),
//      body: Container(
//        color: Colors.white,
//        child: CustomDataTable(
//          flexes: [1, 1, 1, 1],
//          headerColumns: _titles.map<Widget>((title){
//            final int idx = _titles.indexOf(title);
//            TextAlign align = idx < 3 ? TextAlign.left : TextAlign.right;
//            return Text(title, style: TextStyle(fontSize: a.px15, color: Colors.black, fontWeight: FontWeight.w500), textAlign: align);
//          }).toList(),
//          rowBuilder: (index){
//            TradeFlowData data = dataList[index];
//            var row;
//            switch(index){
//              case 0:
//                row = _buildRow(text1: data.title, text2: data.code);
//                break;
//              case 1:
//                //价格/数量
//                row = _buildRow(text1: Utils.getTrisection(data.price), text2: Utils.getTrisectionInt(data.count.toString()), color: Utils.getEntrustTypeColor(data.type));
//                break;
//              case 2:
//                //状态/类型
//                row = _buildRow(text1: data.strState, text2: data.strType);
//                break;
//
//              case 3:
//                //成交时间
//                row = _buildRow(text1: data.strDay, text2: data.strTime, alignment: FractionalOffset.centerRight);
//                break;
//            }
//            return row;
//          },
//          dataList: dataList,
//        ),
//      ),
//    );
//  }
//
//  _buildRow({text1, text2, alignment = FractionalOffset.centerLeft, color}){
//    return Column(
//      children: <Widget>[
//        Align(
//          alignment: alignment,
//          child: Text(text1, style: TextStyle(fontSize: a.px15, fontWeight: FontWeight.w500),),
//        ),
//        SizedBox(height: a.px6,),
//        Align(
//          alignment: alignment,
//          child: Text(text2, style: TextStyle(fontSize: a.px15, color: color, fontWeight: FontWeight.w500),),
//        ),
//      ],
//    );
//  }
//}