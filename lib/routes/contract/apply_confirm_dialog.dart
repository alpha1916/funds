import 'package:flutter/material.dart';
import 'package:funds/common/utils.dart';
import 'package:funds/common/constants.dart';

class ContractApplyConfirmDialog extends Dialog{
  final double money;
  final int integral;
  ContractApplyConfirmDialog(this.money, this.integral);
  @override
  Widget build(BuildContext context) {
    TextStyle blackTextStyle = TextStyle(fontSize: a.px14, color: Colors.black);
    TextStyle redTextStyle = TextStyle(fontSize: a.px14, color: CustomColors.red);
    return Material(
      type: MaterialType.transparency,
      child: Container(
        alignment: Alignment.center,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(a.px6)),
          ),
          width: a.px(320),
          height: a.px(150),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('提示', style: TextStyle(fontSize: a.px20, fontWeight: FontWeight.w700),),
              SizedBox(height: a.px10),
              RichText(
                text: TextSpan(
                  children: <TextSpan>[
                    TextSpan(text: '共计 ', style: blackTextStyle),
                    TextSpan(text: money.toStringAsFixed(2), style: redTextStyle),
                    TextSpan(text: ' 元，可得 ', style: blackTextStyle),
                    TextSpan(text: '$integral', style: redTextStyle),
                    TextSpan(text: ' 积分', style: blackTextStyle),
                  ],
                )
              ),
              Text('支付金额 = 杠杆本金 + 预存管理费', style: TextStyle(fontSize: a.px13, color: Colors.grey)),
              Divider(height: a.px20,),
              Row(
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: InkWell(
                      child: Container(
                        alignment: Alignment.center,
                        child: Text ('取消', style: TextStyle(fontSize: a.px18, color: Colors.black),),
                      ),
                      onTap: () => Utils.navigatePop(false),
                    )
                  ),
                  VerticalDivider(width: 1, indent: a.px2, color: Colors.red,),
                  Expanded(
                    flex: 1,
                    child: InkWell(
                      child: Container(
                        alignment: Alignment.center,
                        child: Text ('立即申请', style: TextStyle(fontSize: a.px18, color: CustomColors.red),),
                      ),
                      onTap: () => Utils.navigatePop(true),
                    )
                  ),
                ],
              )
            ],
          ),
        ),
      )
    );
  }

  static Future<bool> show(money, integral) async{
    return showGeneralDialog<bool>(
      context: Utils.context,
      pageBuilder: (BuildContext buildContext, Animation<double> animation, Animation<double> secondaryAnimation) {
        return ContractApplyConfirmDialog(money, integral);
      },
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(Utils.context).modalBarrierDismissLabel,
      barrierColor: Colors.black38,
      transitionDuration: const Duration(milliseconds: 150),
      transitionBuilder: _buildTransitions,
    );

  }

  static Widget _buildTransitions(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
    return SlideTransition(
      child: child,
      position: Tween(
        begin: Offset(0, 1),
        end: Offset(0, 0),
      ).animate(animation),
    );
  }
}
