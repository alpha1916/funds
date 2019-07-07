import 'package:flutter/material.dart';
import 'package:funds/common/utils.dart';
import 'package:funds/common/constants.dart';

class RewardDialog extends Dialog{
  final String tips;
  RewardDialog(this.tips);
  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Container(
        alignment: Alignment.center,
        margin: EdgeInsets.symmetric(horizontal: a.px50),
        child: Stack(
          children: <Widget>[
            Image.asset(CustomIcons.rewardTray, fit: BoxFit.fitWidth),
            Positioned(
              top: a.px(75),
              left: 0,
              right: 0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('恭喜您！获得以下奖励', style: TextStyle(fontSize: a.px16, color: Colors.black, fontWeight: FontWeight.w700)),
                  SizedBox(height: a.px20,),
                  Text(tips, style: TextStyle(fontSize: a.px20, color: CustomColors.red, fontWeight: FontWeight.w700)),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  static show(tips) async{
    showGeneralDialog(
      context: Utils.context,
      pageBuilder: (BuildContext buildContext, Animation<double> animation, Animation<double> secondaryAnimation) {
        return RewardDialog(tips);
      },
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(Utils.context).modalBarrierDismissLabel,
      barrierColor: Colors.black38,
      transitionDuration: const Duration(milliseconds: 150),
      transitionBuilder: _buildTransitions,
    );

    await Future.delayed(Duration(seconds: 2));
    Utils.navigatePop();
  }

  static Widget _buildTransitions(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
    return SlideTransition(
      child: child,
      position: Tween(
        begin: Offset(0, 1),
        end: Offset(0, -0.05),
      ).animate(animation),
    );
  }
}
