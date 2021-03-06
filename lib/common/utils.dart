import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:funds/pages/trade.dart';
import 'constants.dart';
import 'package:funds/network/http_request.dart';
import 'package:funds/network/user_request.dart';
import 'package:funds/model/account_data.dart';

import 'package:funds/routes/account/login_page.dart';
import 'package:funds/common/custom_dialog.dart';

import 'package:funds/routes/recharge/recharge_page.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:funds/routes/mail/mail_page.dart';
import 'package:funds/routes/my/withdraw_page.dart';
import 'package:funds/routes/online_service_page.dart';
import 'package:funds/routes/online_service_page2.dart';

import 'package:funds/model/list_page_data.dart';

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
      return route.settings.name == '/';
    });

    appMainTabSwitch(tabIndex);
  }

  static buildMyTradeButton() {
    return FlatButton(
      child: const Text('我的交易'),
      onPressed: () {
        if(needLogin())
          return;

        Utils.navigateTo(TradeView(true));
      },
    );
  }

  static buildMailIconButton() {
//    String image = Global.hasUnreadMail == true ? CustomIcons.mail1 : CustomIcons.mail0;
//    return IconButton(
//        icon: Image.asset(image , width: a.px22, height: a.px22),
//        onPressed: () async{
//          if(Global.hasUnreadMail){
//            UserRequest.readMails();
//          }
//
//          var result = await UserRequest.getMailData(MailType.notice.index, 0, 10);
//          if(result.success)
//            Utils.navigateTo(MailPage('消息中心', result.data));
//        }
//    );

    return StreamBuilder<bool>(
        stream: AccountData.getInstance().unreadMailStream,
        initialData: AccountData.getInstance().hasUnreadMail,
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot){
          String image = snapshot.data ? CustomIcons.mail1 : CustomIcons.mail0;
          return IconButton(
              icon: Image.asset(image , width: a.px22, height: a.px22),
              onPressed: () async{
                AccountData.getInstance().readMails();

                var result = await UserRequest.getMailPeekData();
                if(result.success)
                  Utils.navigateTo(MailPage('消息中心', result.data));
              }
          );
        }
    );
  }

  static buildForwardIcon({size, color}) {
    return Icon(Icons.arrow_forward_ios, size: size ?? a.px16, color: color ?? Colors.black26);
  }

  static ListPageDataHandler<CashFlowData> handler;
  static test() async {
    AccountData.getInstance().clear();
  }

  static buildServiceIconButton(BuildContext context) {
    return IconButton(
      icon: Image.asset(CustomIcons.service, width: a.px22, height: a.px22),
      onPressed: (){
        if(Global.debug){
          test();
          return;
        }
        openOnlineService();
      }
    );
  }

  static openOnlineService() {
    if(Global.platformName == 'android')
      navigateTo(OnlineServicePageAndroid());
    else
      navigateTo(OnlineServicePage());
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

  static final RegExp intRegExp = RegExp(r'^\+?[1-9][0-9]*$');
  static int parseInt(String str) {
    if(!intRegExp.hasMatch(str)){
      print('parse int error');
      return null;
    }

    return int.parse(str);
  }
  
  static getTrisectionInt(String strValue){
    List<String> intPartList = [];
    while(strValue.length > 3){
      intPartList.add(strValue.substring(strValue.length - 3, strValue.length));
      strValue = strValue.substring(0, strValue.length - 3);
    }
    intPartList.add(strValue);

    return intPartList.reversed.join(',');
  }

  static login(phone, pwd) async {
    final result = await LoginRequest.login(phone, pwd);
    if(result.success){
      await UserRequest.getUserInfo();
      Utils.navigatePopAll();
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

  static showMoneyEnoughTips() async{
    bool confirm = await showConfirmOptionsDialog(tips: '您的现金余额不足');
    if(confirm)
      Utils.navigateTo(RechargePage());
  }

  static Future<bool> showConfirmOptionsDialog({title = '提示', @required tips, cancelTitle = '取消', confirmTitle = '确定'}) async {
    var selectIdx = await CustomDialog.show3(title, tips, cancelTitle, confirmTitle);
    return selectIdx == 2;
  }

  static expanded(){
    return Expanded(child: Container(color: Colors.transparent));
  }

  static convertPhoneNumber(String phone){
    if(phone == '')
      return '';
    return phone.substring(0, 3) + ' **** ' + phone.substring(7);
  }

  static getObscurePhoneNumber(){
    return convertPhoneNumber(AccountData.getInstance().phone);
  }

  static buildRaisedButton({
    @required title,
    @required onPressed,
    width,
    height,
  }) {
    if(width == null)
      width = a.px(200);
    if(height == null)
      height = a.px48;
    return Container(
      margin: EdgeInsets.only(top: a.px20, bottom: a.px10),
      width: width,
      height: height,
      child: RaisedButton(
        child: Text(
          title,
          style: TextStyle(color: Colors.white, fontSize: a.px18),
        ),
        onPressed: onPressed,
        color: Colors.black,
        shape: StadiumBorder(),
      ),
    );
  }

  static buildUnderlineTextButton(title, fontSize, onPressed) {
    return FlatButton(
      child: Text(
        title,
        style: TextStyle(
          fontSize: fontSize,
          color: Colors.black,
          fontWeight: FontWeight.bold,
          decoration: TextDecoration.underline,
        ),
      ),
      onPressed: onPressed,
    );
  }

  static dial(String phoneNumber) async {
    String url = 'tel:$phoneNumber';
    if(await canLaunch(url)) {
      await launch(url);
    } else {
      print('不能访问');
    }
  }

  static callService() {
//    dial(Global.servicePhoneNumber);
  }

  static openWx() {
    launch('weixin://');
  }

  static bankCardWithdraw() async{
    if(!AccountData.getInstance().bindBank){
      alert('请先绑定银行卡');
      return;
    }
    var result = await UserRequest.getBankCardData();
    if(!result.success)
      return;
    Utils.navigateTo(WithdrawPage(result.data));
    return;
  }

  static showBottomPopupOptions({titles, cancelTitle = '取消'}) async{
    buildItem(BuildContext context, String comment) {
      return CupertinoActionSheetAction(
        child: Text(comment),
        onPressed: () {
          Navigator.pop(context, comment);
        },
      );
    }

    return await showCupertinoModalPopup<String>(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        actions: titles
            .map<Widget>((comment) => buildItem(context, comment))
            .toList(),
        cancelButton: CupertinoActionSheetAction(
          child: Text(cancelTitle),
          isDefaultAction: true,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
    );
  }

  static loadTextAsset(path) async{
    return DefaultAssetBundle.of(context).loadString(path);
  }
}

class CustomTextEditingController extends TextEditingController{
  final bool Function(String) validator;
  final String invalidTips;
  final String regExp;
  CustomTextEditingController({this.validator, this.regExp, this.invalidTips});

  bool approved(){
    bool result = true;
    if(regExp != null){
      result = RegExp(regExp).hasMatch(this.text);
    }else if(validator != null)
      result = validator(this.text);

    if(!result)
      alert(invalidTips);

    return result;
  }

  static CustomTextEditingController buildIDEditingController(){
    final String exp = r'^[1-9][0-7]\d{4}((19\d{2}(0[13-9]|1[012])(0[1-9]|[12]\d|30))|(19\d{2}(0[13578]|1[02])31)|(19\d{2}02(0[1-9]|1\d|2[0-8]))|(19([13579][26]|[2468][048]|0[48])0229))\d{3}(\d|X|x)?$';
    return CustomTextEditingController(invalidTips: '请输入正确的身份证号码', regExp: exp);
  }

  static CustomTextEditingController buildPasswordEditingController(){
    final exp = r'^[a-zA-Z0-9]{6,16}$';
    return CustomTextEditingController(invalidTips: '密码必须为6-16位字母和数字组成', regExp: exp);
  }

  static CustomTextEditingController buildCaptchaEditingController(){
//    final exp = r'^\d{6}$';
    return CustomTextEditingController(invalidTips: '请输入验证码', validator: (str) => str.length > 0 );
  }

  static CustomTextEditingController buildNameEditingController(){
//    final exp = r'^\d{6}$';
    return CustomTextEditingController(invalidTips: '请输入姓名', validator: (str) => str.length > 0 );
  }

  static CustomTextEditingController buildPhoneEditingController(){
    final exp = r'^\d{11}$';
//      final exp = r'^((13[0-9])|(14[0-9])|(15[0-9])|(16[0-9])|(17[0-9])|(18[0-9])|(19[0-9]))\d{8}$';
    return CustomTextEditingController(
      regExp: exp,
      invalidTips: '请输入正确的手机号码',
    );
  }

  static CustomTextEditingController buildInviteCodeEditingController(){
//    final exp = r'^\d{6}$';
//    return CustomTextEditingController(invalidTips: '请输入邀请码', validator: (str) => str.length > 0 );
    return CustomTextEditingController(invalidTips: '请输入邀请码', validator: (str) {
      print(str.length);
      return str.length > 0;
    } );
  }

  static CustomTextEditingController buildBankCardEditingController(){
    return CustomTextEditingController(invalidTips: '请输入银行卡号', validator: (str) => str.length > 0);
  }
}