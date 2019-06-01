import 'package:flutter/material.dart';
import 'package:funds/pages/trade.dart';
import 'constants.dart';

class Utils {
  static buildMyTradeButton(BuildContext context) {
    return FlatButton(
      child: const Text('我的交易'),
      onPressed: () {
        print('press trade');
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => TradeView(true)),
        );
      },
    );
  }

  static buildServiceIconButton(BuildContext context) {
    return IconButton(
        icon: Image.asset(CustomIcons.service, width: CustomSize.icon, height: CustomSize.icon),
        onPressed: (){
          print('press service');
        }
    );
  }
}