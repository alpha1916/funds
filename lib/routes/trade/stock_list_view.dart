import 'package:flutter/material.dart';
import 'package:funds/common/constants.dart';
import 'package:funds/common/utils.dart';
import 'package:funds/model/stock_trade_data.dart';
import 'package:funds/routes/trade/bloc/trade_bloc.dart';

double realWidth;

class StockListView extends StatelessWidget {
  List<StockHoldData> dataList;
  final onItemSelected;

  StockListView(this.onItemSelected);

  @override
  Widget build(BuildContext context) {
    realWidth = MediaQuery.of(context).size.width;
    double leftPadding = a.px10;
    double rightPadding = 0;
    double itemWidth = realWidth - leftPadding - rightPadding;
    List<double> sizeList = _sizeListRate.map((rate) => itemWidth * rate).toList();

    TradeBloc bloc = TradeBloc.getInstance();
    return StreamBuilder<List<StockHoldData>>(
        stream: bloc.holdListStream,
        initialData: bloc.holdList,
        builder: (BuildContext context, AsyncSnapshot<List<StockHoldData>> snapshot){
          dataList = snapshot.data;
          return Container(
            color: Colors.white,
            child: Column(
              children: <Widget>[
                _buildTitleList(sizeList, leftPadding, rightPadding),
                Container(height: a.px1, color: Colors.black12),
                Expanded(
                  child:ListView.builder(
                    itemBuilder: (BuildContext context, int index){
                      return GestureDetector(
                        child: _buildStockItem(index, sizeList, leftPadding, rightPadding),
                        onTap: (){
                          onItemSelected(dataList[index]);
                        },
                      );
                    },
                    itemCount: dataList.length,
                  ),
                ),
              ],
            )
          );
        }
    );

  }

  final _titles = ['名称/代码', '市值/盈亏', '持仓/可用', '成本/现价'];
  final List<double> _sizeListRate = [0.2, 0.4, 0.2, 0.2];

  _buildTitleList(sizeList, leftPadding, rightPadding) {
//    return SizedBox(height: 10,);
    return Container(
      padding: EdgeInsets.only(left: leftPadding, right: rightPadding, top: a.px8, bottom: a.px8),
      child:Row(
        children: _titles.map((title){
          final int idx = _titles.indexOf(title);
          return Container(
            width: sizeList[idx],
            child: Text(title, style: TextStyle(fontSize: a.px15, color: Colors.grey),)
          );
        }).toList(),
      ),
    );
  }

  _buildStockItem(index, sizeList, leftPadding, rightPadding) {
    StockHoldData data = dataList[index];
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
              //市值/盈亏
              Container(
                padding: EdgeInsets.only(left: leftPadding),
                width: sizeList[1],
                child: Column(
                  children: <Widget>[
                    Align(
                      alignment: FractionalOffset.topLeft,
                      child: Text(Utils.getTrisection(data.value), style: TextStyle(fontSize: fontSize),),
                    ),
                    Align(
                      alignment: FractionalOffset.topLeft,
                      child: Text('${Utils.getTrisection(data.profit)}(${data.profitRate})', style: TextStyle(fontSize: fontSize, color: Utils.getProfitColor(data.profit))),
                    ),
                  ],
                ),
              ),
              //持仓/可用
              Container(
                padding: EdgeInsets.only(left: leftPadding, right: a.px5),
                width: sizeList[2],
                child: Column(
                  children: <Widget>[
                    Align(
                      alignment: FractionalOffset.topRight,
                      child: Text(data.hold.toString(), style: TextStyle(fontSize: fontSize),),
                    ),
                    Align(
                      alignment: FractionalOffset.topRight,
                      child: Text(data.usable.toString(), style: TextStyle(fontSize: fontSize)),
                    ),
                  ],
                ),
              ),
              //成本/现价
              Container(
                padding: EdgeInsets.only(left: leftPadding, right: a.px5),
                width: sizeList[3],
                child: Column(
                  children: <Widget>[
                    Align(
                      alignment: FractionalOffset.topRight,
                      child: Text(data.cost.toString(), style: TextStyle(fontSize: fontSize),),
                    ),
                    Align(
                      alignment: FractionalOffset.topRight,
                      child: Text(data.price.toString(), style: TextStyle(fontSize: fontSize, color: Utils.getProfitColor(data.profit))),
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
