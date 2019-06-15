import 'package:flutter/material.dart';
import 'package:funds/pages/trade.dart';
import 'constants.dart';
import 'package:funds/network/http_request.dart';
import 'package:funds/model/account_data.dart';

import 'package:funds/routes/account/login_page.dart';

class Utils {
  static BuildContext context;
  static var appMainTabSwitch;
  static init(ctx, tabSwitcher){
    context = ctx;
    appMainTabSwitch = tabSwitcher;
  }

  static bool needLogin() {
    if(!AccountData.getInstance().isLogin()){
      Utils.navigateToLoginPage();
      return true;
    }
    return false;
  }

  static navigateToLoginPage([isRegister = false]) {
    return navigateTo(LoginPage(isRegister));
  }

  static navigateTo(Widget page) {
    return Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => page),
    );
  }

  static navigatePop([data]) {
    Navigator.of(context).pop(data);
  }

  static navigatePopAll([tabIndex = AppTabIndex.home]) {
    Navigator.of(context).popUntil((Route<dynamic> route) {
//      print(route);
      return route.settings.name == '/';
    });

    appMainTabSwitch(tabIndex);
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

  static test() async {
    AccountData.getInstance().clear();
//    Loading.show();
  }

  static buildServiceIconButton(BuildContext context) {
    return IconButton(
        icon: Image.asset(CustomIcons.service, width: a.px22, height: a.px22),
        onPressed: (){
          print('press service');
          test();
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

  static convertDoubleString(num, [fixed = 2]){
    return num.toStringAsFixed(fixed);
  }

  static double convertDouble(num, [fixed = 2]){
    return double.parse(convertDoubleString(num, fixed));
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
    final result = await LoginRequest.login(phone, pwd);
    if(result.success){
      AccountData.getInstance().updateToken(result.token);
    }

    return result.success;
  }

  static buildFullWidthButton(title, onPressed){
    return Container(
      width: a.screenWidth,
      height: a.px(50),
      child: RaisedButton(
        child: Text(
          title,
          style: TextStyle(color: Colors.white, fontSize: a.px18),
        ),
        onPressed: onPressed,
        color: Colors.black,
      ),
    );
  }
}