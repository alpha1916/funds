import 'package:flutter/material.dart';
import 'package:funds/common/constants.dart';
import 'package:funds/common/utils.dart';
import 'package:funds/network/http_request.dart';

class StockQueryView extends StatefulWidget {
  @override
  _StockQueryViewState createState() => _StockQueryViewState();
}

class _StockQueryViewState extends State<StockQueryView> {
  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          SizedBox(height: a.px14 ),
          _buildItem(width, '当日成交', _onPressDayDeal),
          Container(height: a.px1, margin: EdgeInsets.only(left: a.px16), color: Colors.black12),
          _buildItem(width, '当日委托', _onPressDayDelegate),
          SizedBox(height: a.px14,),
          _buildItem(width, '历史成交', _onPressHistoryDeal),
          Container(height: a.px1, margin: EdgeInsets.only(left: a.px16), color: Colors.black12),
          _buildItem(width, '历史委托', _onPressHistoryDelegate),
          SizedBox(height: a.px14,),
          _buildItem(width, '当日资金流水', _onPressDayCashFlow),
          Container(height: a.px1, margin: EdgeInsets.only(left: a.px16), color: Colors.black12),
          _buildItem(width, '历史资金流水', _onPressHistoryCashFlow),
        ],
      )
    );
  }

  _buildItem(width, title, onPressed) {
    Widget view = Container(
      color: Colors.white,
      width: width,
      padding: EdgeInsets.symmetric(vertical: a.px12, horizontal: a.px16),
      child: Row(
        children: <Widget>[
          Text(title, style: TextStyle(fontSize: a.px16, color: Colors.black87),),
          Expanded(child: Container(),),
          Icon(Icons.arrow_forward_ios, size: a.px20, color: Colors.black26,),
        ],
      ),
    );

    return GestureDetector(
      child: view,
      onTap: onPressed,
    );
  }

  _onPressDayDeal() {
    print('_onPressDayDeal');
  }

  _onPressDayDelegate() {

  }

  _onPressHistoryDeal() {

  }

  _onPressHistoryDelegate() {

  }

  _onPressDayCashFlow() {

  }

  _onPressHistoryCashFlow() {

  }

}

