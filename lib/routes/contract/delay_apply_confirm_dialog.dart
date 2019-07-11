import 'package:flutter/material.dart';
import 'package:funds/common/utils.dart';
import 'package:funds/common/constants.dart';
import 'package:funds/common/custom_dialog.dart';

class ContractDelayApplyConfirmDialog extends Dialog{
  final double money;
  final int integral;
  ContractDelayApplyConfirmDialog(this.money, this.integral);
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
          height: a.px(140),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: a.px20),
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
              Utils.expanded(),
              Divider(height: 0),
              SizedBox(height: a.px15),
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
                  VerticalDivider(width: a.px11, indent: a.px2, color: Colors.red,),
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
              ),
              SizedBox(height: a.px15),
            ],
          ),
        ),
      )
    );
  }

  static Future<bool> show(money, integral) async{
    return CustomDialog.showBottomToCenter(ContractDelayApplyConfirmDialog(money, integral));
  }
}
