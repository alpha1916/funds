import 'package:flutter/material.dart';
import 'package:funds/common/constants.dart';
import 'package:funds/common/utils.dart';
import 'package:funds/model/stock_trade_data.dart';
import 'package:funds/routes/trade/bloc/trade_bloc.dart';

class StockListView extends StatelessWidget {
  final onItemSelected;
  StockListView(this.onItemSelected);
  @override
  Widget build(BuildContext context) {
    TradeBloc bloc = TradeBloc.getInstance();
    return StreamBuilder<List<StockHoldData>>(
        stream: bloc.holdListStream,
        initialData: bloc.holdList,
        builder: (BuildContext context, AsyncSnapshot<List<StockHoldData>> snapshot){
          return Container(
            color: Colors.white,
            child: Column(
              children: <Widget>[
                _buildTitleColumn(),
                Container(height: a.px1, color: Colors.black12),
                _buildDataRows(snapshot.data),
              ],
            )
          );
        }
    );

  }

  final List<int> _rowFlex = [2, 4, 2, 2];
  final List<String> _titles = ['名称/代码', '市值/盈亏', '持仓/可用', '成本/现价'];

  _buildTitleColumn() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: a.px10, vertical: a.px8),
      child:Row(
        children: _titles.map((title){
          final int idx = _titles.indexOf(title);
          TextAlign align = idx < 2 ? TextAlign.left : TextAlign.right;
          return Expanded(
            flex: _rowFlex[idx],
            child: Text(title, style: TextStyle(fontSize: a.px15, color: Colors.grey), textAlign: align,)
          );
        }).toList(),
      ),
    );
  }
  
  _buildDataRows(dataList){
    return Expanded(
      child:ListView.builder(
        itemBuilder: (BuildContext context, int index){
          StockHoldData data = dataList[index];
          return InkWell(
            child: _buildStockItem(data),
            onTap: (){
              onItemSelected(data);
            },
          );
        },
        itemCount: dataList.length,
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
            child: Text(text1, style: TextStyle(fontSize: a.px15),),
          ),
          SizedBox(height: a.px6,),
          Align(
            alignment: alignment,
            child: Text(text2, style: TextStyle(fontSize: a.px15, color: color),),
          ),
        ],
      ),
    );
  }

  _buildStockItem(StockHoldData data) {
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
              //市值/盈亏
              _buildRow(flex: _rowFlex[1], text1: Utils.getTrisection(data.value), text2: '${Utils.getTrisection(data.profit)}(${data.profitRate})', color: Utils.getProfitColor(data.profit)),
              //持仓/可用
              _buildRow(flex: _rowFlex[2], text1: Utils.getTrisectionInt(data.hold.toString()), text2: Utils.getTrisectionInt(data.usable.toString()), color: Utils.getProfitColor(data.profit), alignment: FractionalOffset.centerRight),
              //成本/现价
              _buildRow(flex: _rowFlex[3], text1: Utils.getTrisection(data.cost), text2: Utils.getTrisection(data.price), alignment: FractionalOffset.centerRight),
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
