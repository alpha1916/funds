import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:funds/common/common.dart';
import 'package:funds/model/account_data.dart';
import 'package:funds/network/contract_request.dart';

class CurrentContractWithdrawPage extends StatelessWidget {
  final String contractNumber;
  final double usableCash;
  CurrentContractWithdrawPage(this.contractNumber, this.usableCash);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:Text('提取现金'),
      ),
      body: Container(
        color: CustomColors.background1,
        child: Column(
          children: <Widget>[
            _buildCashView(),
            Utils.buildSplitLine(margin: EdgeInsets.only(left: a.px20)),
            _buildInputView(),
            _buildTipsView(),
            SizedBox(height: a.px30),
            Utils.buildRaisedButton(title: '确认', onPressed: _onPressedOK),
          ],
        ),
      ),
      resizeToAvoidBottomPadding: false,
    );
  }

  _buildCashView() {
    return Container(
      padding: EdgeInsets.all(a.px20),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text('提取金额', style: TextStyle(fontSize: a.px16, fontWeight: FontWeight.w500)),
          Text('${usableCash.toStringAsFixed(2)}元', style: TextStyle(fontSize: a.px16, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  final TextEditingController inputController = TextEditingController();
  _buildInputView(){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: a.px20, vertical: a.px3),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text('可提现金', style: TextStyle(fontSize: a.px16, fontWeight: FontWeight.w500)),
          Expanded(
            child: TextField(
              controller: inputController,
              cursorColor: Colors.black12,
              textAlign: TextAlign.end,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: '请输入提现金额',
                labelStyle: TextStyle(fontSize: a.px20),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _buildTipsView() {
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.all(a.px16),
      child: Text('提取成功后，现金将返还至账户余额中', style: TextStyle(fontSize: a.px14, color: Colors.black54),),
    );
  }

  _onPressedOK() async{
    double inputNumber;
    try{
      inputNumber = double.parse(inputController.text);
    }catch(e){
      alert('请输入正确的数值');
      return;
    }

//    if(inputNumber > AccountData.getInstance().cash){
//      alert('您提现余额不足');
//      return;
//    }

    var result = await ContractRequest.withdraw(contractNumber, inputNumber);
    if(result.success){
      await alert('提现成功');
      Utils.navigatePop(true);
    }
  }
}