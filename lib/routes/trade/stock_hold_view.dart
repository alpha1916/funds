import 'package:flutter/material.dart';
import 'stock_list_view.dart';
import 'package:funds/model/stock_trade_data.dart';

class StockHoldView extends StatelessWidget {
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

