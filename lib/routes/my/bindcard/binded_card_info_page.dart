import 'package:flutter/material.dart';
import 'package:funds/common/common.dart';
import 'package:funds/model/account_data.dart';

class BindedBankCardInfoPage extends StatelessWidget {
  final BankCardData data;
  BindedBankCardInfoPage(this.data);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:Text('我的银行卡'),
      ),
      body: Column(
        children: <Widget>[
          _buildCardView(),
          _buildTipsView(),
        ],
      ),
    );
  }

  _buildCardView() {
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
              Image.network(data.iconUrl, height: a.px30,),
              SizedBox(width: a.px20),
              Text(data.name, style: TextStyle(fontSize: a.px26, color: Colors.white),),
            ],
          ),
          SizedBox(height: a.px50),
          Text('**** **** **** **** ${data.number.substring(data.number.length - 4)}', style: TextStyle(fontSize: a.px30, color: Colors.white),),
          SizedBox(height: a.px50),
        ],
      ),
    );
  }

  _buildTipsView() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text('如需解绑银行卡，', style: TextStyle(fontSize: 16),),
        Utils.buildUnderlineTextButton('联系客服', a.px16, () {
          Utils.callService();
        })
      ],
    );
  }
}
