import 'package:flutter/material.dart';
import 'package:funds/common/constants.dart';
import 'package:funds/common/utils.dart';
import 'package:funds/network/http_request.dart';

class StockSellView extends StatefulWidget {
  @override
  _StockSellViewState createState() => _StockSellViewState();
}

class _StockSellViewState extends State<StockSellView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(child: Text('卖出')),
    );
  }
}

