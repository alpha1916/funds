import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
class CustomIcons {
  static const service = 'assets/common/service.png';
  static const mail0 = 'assets/common/mail0.png';
  static const mail1 = 'assets/common/mail1.png';
  static const rightArrow = 'assets/common/ic_right_arrow.png';
  static const divider = 'assets/common/divider.png';
  static const iconText = 'assets/common/logo_with_text.png';

  static const homeBanner1 = 'assets/home/banner.jpg';
  static const homeBanner2 = 'assets/home/banner2.jpg';
  static const homePeriodPrefix = 'assets/home/period';

  static const fundsPeriodTrayPrefix = 'assets/funds/tray';

  static const trialDone = 'assets/trial/done.png';
  static const trialTypeTray0 = 'assets/trial/type0.png';
  static const trialTypeTray1 = 'assets/trial/type1.png';

  static const myShare = 'assets/my/ic_share.png';
  static const myService = 'assets/my/ic_service.png';
  static const myCoupon = 'assets/my/ic_coupon.png';
  static const myAsset = 'assets/my/ic_asset.png';
  static const myAbout = 'assets/my/ic_about.png';
}

class CustomSize {
  static const double navigationBarIcon = 22;
  static const double navigationBarFontSize = 11;

  static const double icon = 22;
}

class CustomColors {
  static const Color red = Color(0xFFCC2E31);
  static const Color background1 = Color(0xFFE7E7F8);
  static const Color background2 = Color(0xFFEDECF2);

  static const Color trialContentBackground = Color(0xFFFEE3B9);
  static const Color trialBackground = Color(0xFFC51623);
}

class CustomStyles {
  static const TextStyle navigationBarText = TextStyle(
    fontSize: 12,
    color: Colors.black,
  );

  static const TextStyle homeItemStyle1 = TextStyle(
    fontSize: 18,
    color: Colors.black,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle homeItemStyle2 = TextStyle(
    fontSize: 16,
    color: Colors.black87,
  );

  static const TextStyle homeItemStyle3 = TextStyle(
    fontSize: 18,
    color: Colors.red,
    fontWeight: FontWeight.w500,
  );
}

class Constants {
  static const itemTextList = [
    {'title': '天天盈', 'interest': '按天计息'},
    {'title': '周周盈', 'interest': '按周计息'},
    {'title': '月月盈', 'interest': '按月计息'},
    {'title': '互惠盈', 'interest': '免管理费'},
  ];
}

class ContractType {
  static const int trial = 0;
  static const int current = 1;
  static const int history = 2;
}

final desWidth = 414;
adapt(number, realWidth) {
  return number * realWidth / desWidth;
}

alert(BuildContext context, String tips) {
  showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Center(
            child: Text(
              tips,
              textAlign: TextAlign.center,
            )),
        titleTextStyle: TextStyle(fontSize: 16, color: Colors.white),
        backgroundColor: Colors.black87,
      )
  );
}

alert2(BuildContext context, String title, String tips, String btnTitle) {
  final borderColor = Colors.grey;
  showCupertinoDialog(
      context:context,
      builder:(BuildContext context){
        return new CupertinoAlertDialog(
          title: new Text(
            title,
          ),
          content: new Text(tips),
          actions: <Widget>[
            new Container(
              decoration: BoxDecoration(
                  border: Border(right:BorderSide(color: borderColor,width: 1.0),top:BorderSide(color: borderColor,width: 1.0))
              ),
              child: FlatButton(
                child: new Text(btnTitle, style: TextStyle(color: Colors.blueAccent),),
                onPressed:(){
                  Navigator.pop(context);
                },
              ),
            ),
//            new Container(
//              decoration: BoxDecoration(
//                  border: Border(top:BorderSide(color: borderColor,width: 1.0))
//              ),
//              child: FlatButton(
//                child: new Text("取消"),
//                onPressed:(){
//                  Navigator.pop(context);
//                },
//              ),
//            )
          ],
        );
      }
  );
}
