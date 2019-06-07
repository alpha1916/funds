import 'package:flutter/material.dart';
import 'package:funds/pages/trade.dart';
import 'constants.dart';
import 'package:funds/network/http_request.dart';
import 'package:funds/model/account_data.dart';

class Utils {
  static BuildContext context;
  static init(ctx){
    context = ctx;
  }

  static navigateTo(Widget page) {
    return Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => page),
    );
  }

  static navigatePop(data) {
    Navigator.of(context).pop(data);
  }

  static buildMyTradeButton(BuildContext context) {
    return FlatButton(
      child: const Text('我的交易'),
      onPressed: () {
        print('press trade');
        Utils.navigateTo(TradeView(true));
      },
    );
  }

  static buildServiceIconButton(BuildContext context) {
    return IconButton(
        icon: Image.asset(CustomIcons.service, width: a.px22, height: a.px22),
        onPressed: (){
          print('press service');
          HttpRequest.getRegisterCaptcha('18666612345');
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

    while(strIntPart.length > 3){
      intPartList.add(strIntPart.substring(strIntPart.length - 4, strIntPart.length - 1));
      strIntPart = strIntPart.substring(0, strIntPart.length - 3);
    }
    intPartList.add(strIntPart);

    return sign + intPartList.reversed.join(',') + '.' + tmp[1];

  }

  static login(phone, pwd) async {
    final result = await AccountRequest.login(phone, pwd);
    if(result.success){
      AccountData.getInstance().updateToken(result.token);
    }

    return result.success;
  }
}