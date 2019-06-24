import 'package:flutter/material.dart';
import 'package:funds/common/common.dart';

class BindedBankCardInfoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String phoneNumber = '18666612345';
    return Scaffold(
      appBar: AppBar(
        title:Text('我的银行卡'),
      ),
      body: Container(
        color: CustomColors.background1,
        child: Column(
          children: <Widget>[
            _buildCardView(),
            _buildTipsView(phoneNumber),
          ],
        ),
      ),
    );
  }

  _buildCardView() {
    String url = 'http://www.cmbchina.com/cmb.ico';
    String name = '招商银行';
    return Container(
      margin: EdgeInsets.all(a.px20),
      decoration: BoxDecoration(
        color: Color(0xFF616170),
        borderRadius: BorderRadius.all(Radius.circular(a.px30)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(height: a.px30),
          Row(
            children: <Widget>[
              SizedBox(width: a.px30),
              Image.network(url, height: a.px30,),
              SizedBox(width: a.px20),
              Text(name, style: TextStyle(fontSize: a.px26, color: Colors.white),),
            ],
          ),
          SizedBox(height: a.px50),
          Text('**** **** **** **** 6789', style: TextStyle(fontSize: a.px30, color: Colors.white),),
          SizedBox(height: a.px50),
        ],
      ),
    );
  }

  _buildTipsView(phoneNumber) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text('如需解绑银行卡，', style: TextStyle(fontSize: 16),),
        Utils.buildUnderlineTextButton('联系客服', a.px16, () {
          Utils.dial(phoneNumber);
        })
      ],
    );
  }
}
