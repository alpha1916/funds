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
  
  static getProfitColor(value) {
    Color color;
    if(value > 0)
      color = CustomColors.red;
    else if(value < 0)
      color = Colors.green;
    else
      color = Colors.black;

    return color;
  }

  static getTrisection(double value) {
    String sign = '';
    if(value < 0){
      sign = '-';
      value = -value;
    }
    List<String> tmp = value.toStringAsFixed(2).split('.');
    List<String> intPartList = [];
    String strIntPart = tmp[0];
    print(strIntPart);

    while(strIntPart.length > 3){
      intPartList.add(strIntPart.substring(strIntPart.length - 4, strIntPart.length - 1));
      strIntPart = strIntPart.substring(0, strIntPart.length - 3);
    }
    intPartList.add(strIntPart);

    return sign + intPartList.reversed.join(',') + '.' + tmp[1];

  }
}