import 'package:flutter/material.dart';
import 'package:funds/common/constants.dart';
import 'package:funds/common/utils.dart';
import 'package:funds/network/http_request.dart';
import 'stock_list_view.dart';
import 'package:funds/model/stock_trade_data.dart';

class StockHoldView extends StatefulWidget {
  @override
  _StockHoldViewState createState() => _StockHoldViewState();
}

class _StockHoldViewState extends State<StockHoldView> {
  List<StockHoldData> _dataList = [];


  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: StockListView(_onSelectStock),
    );
  }

  _onSelectStock(StockHoldData data) {
    print(data.title);
  }
}

