import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'custom_dialog.dart';
import 'dart:io';

class CustomIcons {
  static const service = 'assets/common/service.png';
  static const mail0 = 'assets/common/mail0.png';
  static const mail1 = 'assets/common/mail1.png';
  static const iconText = 'assets/common/logo_with_text.png';
  static const iconWithdraw = 'assets/common/ic_drawing_psw.png';
  static const logo = 'assets/common/ic_logo.png';

  static const couponBG1 = 'assets/common/bg_coupon_blue.png';
  static const couponBG2 = 'assets/common/bg_coupon_orange.png';
  static const couponBG3 = 'assets/common/bg_coupon_red.png';
  static const rewardTray = 'assets/common/bg_reward_dialog.png';


  static const homeBanner1 = 'assets/home/banner.jpg';
  static const homeBanner2 = 'assets/home/banner2.jpg';
  static const homePeriodPrefix = 'assets/home/period';

  static const fundsPeriodTrayPrefix = 'assets/funds/tray';

  static const trialDone = 'assets/trial/done.png';
  static const trialTypeTray0 = 'assets/trial/type0.png';
  static const trialTypeTray1 = 'assets/trial/type1.png';
  static const profitRateTray = 'assets/trial/profit_rate_tray.png';

  static const myShare = 'assets/my/ic_share.png';
  static const myService = 'assets/my/ic_service.png';
  static const myCoupon = 'assets/my/ic_coupon.png';
  static const myAsset = 'assets/my/ic_asset.png';
  static const myAbout = 'assets/my/ic_about.png';
//  static const version = 'assets/my/ic_version.png';
  static const gold = 'assets/my/ic_gold.png';
  static const integral = 'assets/my/ic_integral.png';
  static const task = 'assets/my/ic_task.png';
  static const camera = 'assets/my/camera.png';
  static const photo = 'assets/my/photo.png';
  static const rechargeSample = 'assets/my/recharge_sample.png';

  static const sign = 'assets/task/ic_sign.png';
  static const signChecked = 'assets/task/ic_sign_in_check.png';
  static const coupon = 'assets/task/ic_coupon.png';

  static const meter = 'assets/contract/meter.png';
  static const meterArrow = 'assets/contract/meter_arrow.png';
  static const expire = 'assets/contract/expire.png';

  static const companyIntro = 'assets/about/ic_company_intro.png';
  static const media = 'assets/about/ic_media_report.png';
  static const concern = 'assets/about/ic_concern_wx.png';
  static const share = 'assets/about/ic_share.png';
  static const suggest = 'assets/about/ic_suggest.png';
  static const serviceItems = 'assets/about/ic_items.png';
  static const version = 'assets/about/ic_version.png';
  static const wxQRCode = 'assets/about/ic_wx_qr_code.png';

  static const helpBasic = 'assets/help/ic_help_base_intro.png';
  static const helpTrade = 'assets/help/ic_help_trade.png';
  static const helpCash = 'assets/help/ic_help_cash.png';
  static const phoneService = 'assets/help/ic_phone_service.png';
  static const onlineService = 'assets/help/ic_online_service.png';
}

class TextAssets {
  static const riskTips = 'assets/riskTips.txt';
}

class CustomColors {
  static const Color red = Color(0xFFCC2E31);
  static const Color background1 = Color(0xFFE7E7F8);
  static const Color background2 = Color(0xFFEDECF2);

  static const Color backgroundBlue = Color(0xFF201F46);
  static const Color textGold = Color(0xFFFDC336);

  static const Color splitLineColor1 = Color(0x5A000000);

  static const Color trialContentBackground = Color(0xFFFEE3B9);
  static const Color trialBackground = Color(0xFFC51623);

}

class AppTabIndex{
  static const int home = 0;
  static const int experience = 1;
  static const int funds = 2;
  static const int trade = 3;
  static const int my = 4;
}

class ContractType {
  static const int trial = 0;
  static const int current = 1;
  static const int history = 2;
}

class TradeType {
  static const int buy = 1;
  static const int sell = 2;
}

class StateType {
  static const int deal = 1;//已成交
  static const int noDeal = 2;//未成交
  static const int partDeal = 3;//部分成交
}

class ContractOperate {
  static const int addMoney = 1;
  static const int applySettlement = 2;
  static const int delaySell = 3;
  static const int applySuspendedCycle = 4;
}

alert(String tips) {
  return CustomDialog.show(tips);
}

alert2(String title, String tips, String btnTitle) {
  return CustomDialog.show2(title, tips, btnTitle);
}

class a{
//  static double screenWidth;
  static double ratio;
  static double screenWidth;
  static double screenHeight;

  static double px1;
  static double px2;
  static double px3;
  static double px4;
  static double px5;
  static double px6;
  static double px7;
  static double px8;
  static double px9;
  static double px10;
  static double px11;
  static double px12;
  static double px13;
  static double px14;
  static double px15;
  static double px16;
  static double px17;
  static double px18;
  static double px19;
  static double px20;
  static double px21;
  static double px22;
  static double px23;
  static double px24;
  static double px25;
  static double px26;
  static double px27;
  static double px28;
  static double px29;
  static double px30;
  static double px31;
  static double px32;
  static double px33;
  static double px34;
  static double px35;
  static double px36;
  static double px37;
  static double px38;
  static double px39;
  static double px40;
  static double px41;
  static double px42;
  static double px43;
  static double px44;
  static double px45;
  static double px46;
  static double px47;
  static double px48;
  static double px49;
  static double px50;

  static init(double width, double height){
    screenWidth = width;
    screenHeight = height;
    ratio = screenWidth / 414;

    px1 = px(1);
    px2 = px(2);
    px3 = px(3);
    px4 = px(4);
    px5 = px(5);
    px6 = px(6);
    px7 = px(7);
    px8 = px(8);
    px9 = px(9);
    px10 = px(10);
    px11 = px(11);
    px12 = px(12);
    px13 = px(13);
    px14 = px(14);
    px15 = px(15);
    px16 = px(16);
    px17 = px(17);
    px18 = px(18);
    px19 = px(19);
    px20 = px(20);
    px21 = px(21);
    px22 = px(22);
    px23 = px(23);
    px24 = px(24);
    px25 = px(25);
    px26 = px(26);
    px27 = px(27);
    px28 = px(28);
    px29 = px(29);
    px30 = px(30);
    px31 = px(31);
    px32 = px(32);
    px33 = px(33);
    px34 = px(34);
    px35 = px(35);
    px36 = px(36);
    px37 = px(37);
    px38 = px(38);
    px39 = px(39);
    px40 = px(40);
    px41 = px(41);
    px42 = px(42);
    px43 = px(43);
    px44 = px(44);
    px45 = px(45);
    px46 = px(46);
    px47 = px(47);
    px48 = px(48);
    px49 = px(49);
    px50 = px(50);

//    for(var i = 11; i < 51; ++i){
//      print('static double px$i;');
//    }
//
//    for(var i = 11; i < 51; ++i){
//      print('px$i = px($i);');
//    }
  }

  static double px(double num){
    return num * ratio;
  }
}

class Global{
  static BuildContext buildContext;
//  static bool debug = false;
  static bool debug = !bool.fromEnvironment("dart.vm.product") ;
  static String version = '0.0.5';
  static String servicePhoneNumber = '4001234567';
  static String get platformName {
    if(Platform.isIOS){
      return 'ios';
    }else if(Platform.isAndroid){
      return 'android';
    }
    return 'unknown';
  }

  static String testPhoneNumber = '18612345658';
  static String testPwd = '123456';
}

final Map<int, String>tradeFlowStatus = {
  -1: '委托失败',
  0: '委托中',
  1: '未报',
  2: '未报',
  3: '未报',
  4: '已报',
  5: '废单',
  6: '部分成交',
  7: '已成交',
  8: '部分撤单',
  9: '已撤单',
  10: '待撤单',
};