import 'package:flutter/material.dart';
import 'package:funds/common/constants.dart';
import 'package:funds/common/utils.dart';
import 'package:funds/model/account_data.dart';

import 'package:funds/routes/recharge/recharge_page.dart';
//import 'package:funds/network/user_request.dart';
import 'package:funds/routes/my/withdraw_page.dart';
import 'cash_flow_page.dart';

class FundsDetailPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:Text('资金明细'),
      ),
      body: Container(
        color: CustomColors.background1,
        child: Column(
          children: <Widget>[
            _buildTopView(),
            SizedBox(height: a.px10,),
            Container(
              color: Colors.white,
              child: Column(
                children: <Widget>[
//                  _buildNumberItemView(CustomIcons.gold, '金币流水', 0, _onPressedGold),
//                  Utils.buildSplitLine(margin: EdgeInsets.only(left: a.px20)),
                  _buildNumberItemView(CustomIcons.integral, '积分流水', 0, _onPressedIntegral),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  _buildTopView() {
    return GestureDetector(
      child: Container(
        color: CustomColors.backgroundBlue,
        padding: EdgeInsets.symmetric(vertical: a.px25),
        child: Column(
          children: <Widget>[
            Text('现金账户', style: TextStyle(fontSize: a.px16, color: Colors.white),),
            SizedBox(width: double.infinity, height: a.px20,),
            Text(AccountData.getInstance().cash.toStringAsFixed(2), style: TextStyle(fontSize: a.px36, color: CustomColors.textGold),),
            Container(
              padding: EdgeInsets.only(right: a.px20, top: a.px10, bottom: a.px20),
              alignment: Alignment.centerRight,
              child: Utils.buildForwardIcon(size: a.px20, color: Colors.white70),
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  _buildButton('提现', Colors.black87, Colors.white, _onPressWithdraw),
                  _buildButton('充值', Colors.white, CustomColors.red, _onPressCharge),
                ],
              ),
            ),
          ],
        ),
      ),
      onTap: () => Utils.navigateTo(CashFlowPage()),
    );
  }

  Widget _buildButton(title, titleColor, color, onPressed) {
    return Container(
      child:RaisedButton(
        child: Text(
          title,
          style: TextStyle(color: titleColor, fontSize: a.px16),
        ),
        onPressed: onPressed,
        color: color,
        shape: StadiumBorder(),
      ),
      width: a.px(120),
      height: a.px40,
    );
  }

  _buildNumberItemView(icon, title, value, onPressed){
    return GestureDetector(
      child: Container(
        padding: EdgeInsets.all(a.px16),
        color: Colors.white,
        child: Row(
          children: <Widget>[
            Image.asset(icon, width: a.px20,),
            SizedBox(width: a.px16,),
            Text(title, style: TextStyle(fontSize: a.px16, fontWeight: FontWeight.w500),),
            Utils.expanded(),
            Text(value.toString(), style: TextStyle(fontSize: a.px16, fontWeight: FontWeight.w400),),
            SizedBox(width: a.px10,),
            Utils.buildForwardIcon(),
          ],
        ),
      ),
      onTap: onPressed,
    );
  }

  _onPressCharge() async {
    Utils.navigateTo(RechargePage());
//    _refresh();
  }

  _onPressWithdraw() {
    Utils.bankCardWithdraw();
  }

  _onPressedGold() {

  }

  _onPressedIntegral() {

  }
}
