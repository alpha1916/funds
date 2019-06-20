import 'package:flutter/material.dart';
import 'package:funds/pages/trade.dart';
import 'constants.dart';
import 'package:funds/network/http_request.dart';
import 'package:funds/model/account_data.dart';

import 'package:funds/routes/account/login_page.dart';
import 'package:funds/common/custom_dialog.dart';

import 'package:funds/routes/recharge/recharge_page.dart';

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
        if(needLogin())
          return;

        Utils.navigateTo(TradeView(true));
      },
    );
  }

  static buildForwardIcon([size, color]) {
    return Icon(Icons.arrow_forward_ios, size: size ?? a.px16, color: color ?? Colors.black26,);
  }

  static test() async {
    AccountData.getInstance().clear();
//    var data = {
//      'code': '666666',
//      'title': '招商银行',
//      'price': 6.66,
//      'count': '200',
//    };
//    var confirm = await CustomAlert.showCustomDialog(TradeConfirmDialog(TradeType.buy, data));
//    print(confirm);
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

  static Color getEntrustTypeColor(type) {
    if(type == TradeType.buy)
      return Utils.getProfitColor(1);
    else
      return Utils.getProfitColor(-1);
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
//    List<String> intPartList = [];
//    String strIntPart = tmp[0];
//
//    while(strIntPart.length > 3){
//      intPartList.add(strIntPart.substring(strIntPart.length - 4, strIntPart.length - 1));
//      strIntPart = strIntPart.substring(0, strIntPart.length - 3);
//    }
//    intPartList.add(strIntPart);
//
//    return sign + intPartList.reversed.join(',') + '.' + tmp[1];
    String strIntPart = getTrisectionInt(tmp[0]);
    return sign + strIntPart + '.' + tmp[1];

  }
  
  static getTrisectionInt(String strValue){
    List<String> intPartList = [];
    while(strValue.length > 3){
      intPartList.add(strValue.substring(strValue.length - 4, strValue.length - 1));
      strValue = strValue.substring(0, strValue.length - 3);
    }
    intPartList.add(strValue);

    return intPartList.reversed.join(',');
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

  static buildSplitLine({
    height,
    margin,
    color = Colors.black12,
  }){
    if(height == null)
      height = a.px(0.5);

    return Container(
      margin: margin,
      color: color,
      height: height,
    );
  }

  static showMoneyEnoughTips() async{
    bool confirm = await showConfirmOptionsDialog(tips: '您的现金余额不足');
    if(confirm)
      Utils.navigateTo(RechargePage());
  }

  static Future<bool> showConfirmOptionsDialog({title = '提示', tips, cancelTitle = '取消', confirmTitle = '确定'}) async {
    var selectIdx = await CustomDialog.show3(title, tips, cancelTitle, confirmTitle);
    return selectIdx == 2;
  }

  static isValidPhoneNumber(String str) {
    return str.length == 11;
//    return RegExp(r'^((13[0-9])|(14[0-9])|(15[0-9])|(16[0-9])|(17[0-9])|(18[0-9])|(19[0-9]))\d{8}$').hasMatch(str);
  }

  static isValidPassword(String str) {
    final exp = r'^[a-zA-Z0-9]{6,16}$';
    return RegExp(exp).hasMatch(str);
  }

  static expanded(){
    return Expanded(child: Container());
  }

  static convertPhoneNumber(String phone){
    if(phone == '')
      return '';
    return phone.substring(0, 3) + ' **** ' + phone.substring(7);
  }
}