import 'package:flutter/material.dart';
import 'package:funds/common/constants.dart';
import 'package:funds/common/utils.dart';

import 'package:funds/common/widgets/custom_refresh_list_view.dart';
import 'package:funds/model/list_page_data.dart';
import 'package:funds/model/contract_data.dart';


class TradeFlowPage extends StatelessWidget {
  final ListPageDataHandler listPageDataHandler;
  final String title;
  final int type;
  TradeFlowPage(this.title, this.type, this.listPageDataHandler);

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
              _buildListView(),
            ],
          )
      ),
    );
  }

  _buildListView() {
    return Expanded(
      child: CustomRefreshListView(
        indexedWidgetBuilder: _itemBuilder,
        refreshHandler: listPageDataHandler.refresh,
        loadMoreHandler: listPageDataHandler.loadMore,
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

  Widget _itemBuilder(BuildContext context, int index, dynamic srcData){
    TradeFlowData data = srcData;
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
              _buildRow(flex: _rowFlex[2], text1: data.strState, text2: data.strType, color: Utils.getEntrustTypeColor(data.type)),
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