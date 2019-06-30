import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:funds/common/common.dart';
import 'package:funds/model/account_data.dart';
import 'package:funds/routes/account/forget_password_page.dart';
import 'package:funds/network/user_request.dart';

class WithdrawPage extends StatelessWidget {
  final BankCardData data;
  WithdrawPage(this.data);
  @override
  Widget build(BuildContext context) {
    String phoneNumber = '18666612345';
    return Scaffold(
      appBar: AppBar(
        title:Text('我的银行卡'),
      ),
      body: Column(
        children: <Widget>[
          _buildCardView(),
          _buildInputView(),
          _buildTipsView(),
          SizedBox(height: a.px30),
          Utils.buildRaisedButton(title: '确认提现', onPressed: _onPressedOK),
          _buildServiceView(phoneNumber),
        ],
      ),
      resizeToAvoidBottomPadding: false,
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

  _buildServiceView(phoneNumber) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text('提现遇到问题？', style: TextStyle(fontSize: a.px16),),
        Utils.buildUnderlineTextButton('联系客服', a.px16, () {
          Utils.dial(phoneNumber);
        })
      ],
    );
  }

  final TextEditingController inputController = TextEditingController();
  _buildInputView(){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: a.px20, vertical: a.px3),
      color: Colors.white,
      child: Row(
        children: <Widget>[
          Image.asset(CustomIcons.iconWithdraw, width: a.px18),
          SizedBox(width: a.px10),
          Expanded(
            child: TextField(
              controller: inputController,
//              keyboardType: TextInputType.numberWithOptions(decimal: true),
//              textInputAction: TextInputAction.done,
              cursorColor: Colors.black12,
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
    var style = TextStyle(fontSize: a.px14, color: Colors.black54);
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.all(a.px16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Text('钱包余额 ', style: style,),
              Text('${AccountData.getInstance().cash} 元', style: TextStyle(fontSize: a.px14, color: CustomColors.red),),
            ],
          ),
          Text('单日提款超5万元，分多笔到账；超10万元，T+1到账', style: style,),
          Text('工作日15点前提现当日到账，15点后提现T+1到账', style: style,),
        ],
      ),
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

    if(inputNumber < 100){
      alert('最低提现金额为\n100');
      return;
    }

    if(inputNumber > AccountData.getInstance().cash){
      alert('您提现余额不足');
      return;
    }
    String password = await showQueryPasswordDialog();
    if(password != null){
      var result = await RechargeRequest.withdraw(inputNumber, password);
      if(result.success){
        await alert('提现申请已提交');
        await UserRequest.getUserInfo();
        Utils.navigatePop();
      }
    }
  }

  showQueryPasswordDialog() async{
    buildButton(title, [onPressed]){
      return Container(
        decoration: BoxDecoration(
            border: Border(
              top: BorderSide(color: Colors.grey, width: 1.0),
              right: BorderSide(color: Colors.grey, width: 0.5),
            )),
        child: FlatButton(
          child: new Text(title, style: TextStyle(color: Colors.blueAccent, fontSize: a.px20)),
          onPressed: () {
            if(onPressed == null)
              Utils.navigatePop();
            else
              onPressed();
          },
        ),
      );
    }
    final TextEditingController passController = TextEditingController();
    buildInputView(){
      return Container(
//        margin: EdgeInsets.only(left: a.px10),
//        width: a.px(200),
        child: Column(
          children: <Widget>[
            TextField(
              controller: passController,
              cursorColor: Colors.black12,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: '请输入密码',
                labelStyle: TextStyle(fontSize: a.px20),
              ),
              autofocus: false,
              obscureText: true,
            ),
            SizedBox(height: a.px10,),
            Row(
              children: <Widget>[
                Utils.expanded(),
                InkWell(
                  child: Text('忘记提款密码？', style: TextStyle(fontSize: a.px16, color: Colors.blueAccent),),
                  onTap: () { Utils.navigateTo(ForgetPasswordPage()); },
                ),
              ],
            ),
          ],
        ),
      );
    }

    onConfirmPassword() {
      if(passController.text.length == 0){
        alert('请输入密码');
        return;
      }

      Utils.navigatePop(passController.text);
    }

    return showCupertinoDialog(
        context: Utils.context,
        builder: (BuildContext context) {
          return new CupertinoAlertDialog(
            title: Text('提示'),
            content: Material(child:buildInputView()),
            actions: <Widget>[
              buildButton('取消'),
              buildButton('确定', onConfirmPassword),
            ],
          );
        }
    );
  }
}
