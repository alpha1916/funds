import 'package:flutter/material.dart';
import 'package:funds/common/constants.dart';
import 'package:funds/common/utils.dart';
import 'package:funds/network/contract_request.dart';
import 'package:funds/model/account_data.dart';

class ContractAddCapitalPage extends StatelessWidget {
  final contractNumber;
  final minValue;
  ContractAddCapitalPage(this.contractNumber, this.minValue);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:Text('追加本金'),
      ),
      body: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(horizontal: a.px16, vertical: a.px16),
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('现金余额', style: TextStyle(fontSize: a.px16, fontWeight: FontWeight.w500),),
                Text('${AccountData.getInstance().cash}元', style: TextStyle(fontSize: a.px16, fontWeight: FontWeight.w500),),
              ],
            ),
          ),
          Divider(height: a.px1, indent: a.px16),
          Container(
            padding: EdgeInsets.symmetric(horizontal: a.px16, vertical: a.px2),
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('追加本金', style: TextStyle(fontSize: a.px16, fontWeight: FontWeight.w500),),
                _buildInputView(),
              ],
            ),
          ),
//          Container(
//            padding: EdgeInsets.symmetric(horizontal: a.px16, vertical: a.px12),
//            child: Row(
//              children: <Widget>[
//                Text('追加本金不能少于总操盘资金1%，最低可追加 ', style: TextStyle(fontSize: a.px13),),
//                Text(minValue.toStringAsFixed(2), style: TextStyle(fontSize: a.px14, color: CustomColors.red),),
//                Text(' 元', style: TextStyle(fontSize: a.px13),),
//              ],
//            ),
//          ),
          SizedBox(height: 40),
          Container(
            width: a.px(180),
            height: a.px50,
            child:RaisedButton(
              child: Text('确认', style: TextStyle(color: Colors.white, fontSize: a.px15),),
                onPressed: _onPressedOK,
                color: Colors.black,
                shape: StadiumBorder(),
            ),
          ),
        ],
      ),
      resizeToAvoidBottomPadding: false,
    );
  }

  final TextEditingController _inputController = TextEditingController();
  _buildInputView() {
    return Container(
      width: a.px(200),
      child: TextField(
        textAlign: TextAlign.right,
        controller: _inputController,
        cursorColor: Colors.black12,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: '请输入追加金额',
          labelStyle: TextStyle(fontSize: a.px16),
        ),
        autofocus: false,
      ),
    );
  }

  _onPressedOK() async{
    if(_inputController.text.length == 0){
      alert('请输入追加金额');
      return;
    }

    int inputNum = int.parse(_inputController.text);
//    if(inputNum < minValue){
//      alert('追加本金不能少于总操盘资金1%');
//      return;
//    }

    if(inputNum > AccountData.getInstance().cash){
      Utils.showMoneyEnoughTips();
      return;
    }

    ResultData result = await ContractRequest.addCapital(contractNumber, inputNum);
    if(result.success){
      await alert('追加保证金成功');
      Utils.navigatePop(true);
    }
  }
}
