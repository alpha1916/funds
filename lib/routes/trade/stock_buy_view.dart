import 'package:flutter/material.dart';
import 'package:funds/common/constants.dart';
import 'package:funds/common/utils.dart';
import 'package:funds/network/http_request.dart';

class StockBuyView extends StatefulWidget {
  @override
  _StockBuyViewState createState() => _StockBuyViewState();
}

class _StockBuyViewState extends State<StockBuyView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(child: Text('买入')),
    );
  }
}

