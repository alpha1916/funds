import 'package:flutter/material.dart';
import 'package:funds/common/constants.dart';
import 'package:funds/common/utils.dart';
import 'package:funds/model/account_data.dart';
import 'package:funds/network/http_request.dart';
import 'modify_password_page.dart';
import 'modify_bind_phone_verify_page.dart';
import 'modify_address_page.dart';
import 'certification_page.dart';
import 'package:funds/network/user_request.dart';
import 'package:funds/routes/my/bindcard/bind_bank_card_page.dart';
import 'package:funds/routes/my/bindcard/binded_card_info_page.dart';

class SettingsPage extends StatelessWidget {
  final forwardIcon = Utils.buildForwardIcon();
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AccountData>(
        stream: AccountData.getInstance().dataStream,
        initialData: AccountData.getInstance(),
        builder: (BuildContext context, AsyncSnapshot<AccountData> snapshot){
          AccountData data = snapshot.data;
          return Scaffold(
            appBar: AppBar(
              title:Text('个人设置'),
            ),
            body: Container(
              color: CustomColors.background1,
              child: Column(
                children: <Widget>[
                  _buildSettableItem('联系地址', data.address != '', _onPressedModifyAddress),
                  SizedBox(height: a.px10),
                  _buildNameView(data.name),
                  Utils.buildSplitLine(margin: EdgeInsets.only(left: a.px16)),
                  _buildSettableItem('绑定银行卡', data.bankcard != '', _onPressedModifyBankCard),
                  Utils.buildSplitLine(margin: EdgeInsets.only(left: a.px16)),
                  _buildSettableItem('绑定手机号', true, _onPressedBindPhone, Utils.convertPhoneNumber(AccountData.getInstance().phone)),
                  SizedBox(height: a.px10),

                  _buildSettableItem('登录密码', true, _onPressedModifyPassword),
                  SizedBox(height: a.px10),

                  _buildSettableItem('退出当前账号', true, _onPressedLogout, ' '),
                ],
              ),
            ),
          );
        }
    );
  }

  _buildSettableItem(title, setup, onPressed, [rightText = '']){
    String setupText;
    Color setupTextColor;
    if(setup){
      setupText = '已设置';
      setupTextColor = Colors.black;
    }else{
      setupText = '未设置';
      setupTextColor = CustomColors.red;
    }
    if(rightText != '')
      setupText = rightText;

    return GestureDetector(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: a.px16, vertical: a.px16),
        color: Colors.white,
        child: Row(
          children: <Widget>[
            Text(title, style: TextStyle(fontSize: a.px16),),
            Utils.expanded(),
            Text(setupText, style: TextStyle(fontSize: a.px16, color: setupTextColor),),
            forwardIcon,
          ],
        ),
      ),
      onTap: onPressed,
    );
  }

  _buildNameView(name){
    if(name == '')
      return _buildSettableItem('实名认证', false, _onPressedCertification);
    else{
      return Container(
        padding: EdgeInsets.symmetric(horizontal: a.px16, vertical: a.px16),
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text('实名认证', style: TextStyle(fontSize: a.px16),),
            Text(name, style: TextStyle(fontSize: a.px16),),
          ],
        )
      );
    }

  }

  _onPressedModifyAddress() {
    Utils.navigateTo(ModifyAddressPage());
  }

  _onPressedCertification() async {
    var result = await Utils.navigateTo(CertificationPage());
    if(result == true){
      UserRequest.getUserInfo();
    }
  }

  _onPressedModifyBankCard() async{
    if(AccountData.getInstance().name == ''){
      bool confirm = await Utils.showConfirmOptionsDialog(tips: '绑卡前，请先进行实名认证', confirmTitle: '前往认证');
      if(confirm)
        _onPressedCertification();
      return;
    }

//    if(true){
//      Utils.navigateTo(BindedBankCardInfoPage());
//      return;
//    }

    var result = await Utils.navigateTo(BindBankCardPage());
    if(result == true){
      UserRequest.getUserInfo();
    }
  }

  _onPressedBindPhone() {
    Utils.navigateTo(ModifyPhoneVerifyPage());
  }

  _onPressedModifyPassword() {
    Utils.navigateTo(ModifyPasswordPage());
  }

  _onPressedLogout() async{
    bool confirm = await Utils.showConfirmOptionsDialog(tips: '退出当前账号');
    if(!confirm)
      return;

    await AccountData.getInstance().clear();
    Utils.navigatePopAll();
  }
}
