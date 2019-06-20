import 'package:flutter/material.dart';
import 'package:funds/common/constants.dart';
import 'package:funds/common/utils.dart';
import 'package:funds/model/account_data.dart';
import 'package:funds/network/http_request.dart';
import 'package:funds/common/widgets/phone_captcha_button.dart';

class SettingsPage extends StatelessWidget {
  final forwardIcon = Utils.buildForwardIcon();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:Text('个人设置'),
      ),
      body: Container(
        color: CustomColors.background1,
        child: Column(
          children: <Widget>[
            _buildItemView('联系地址', '', _onPressedModifyAddress),
            SizedBox(height: a.px10),

            _buildItemView('实名认证', '名字', _onPressedModifyAddress),
            Utils.buildSplitLine(margin: EdgeInsets.only(left: a.px16)),
            _buildItemView('绑定银行卡', '已设置', _onPressedModifyAddress),
            Utils.buildSplitLine(margin: EdgeInsets.only(left: a.px16)),
            _buildItemView('绑定手机号', '139****7109', _onPressedModifyAddress),
            SizedBox(height: a.px10),

            _buildItemView('登录密码', '已设置', _onPressedModifyAddress),
            SizedBox(height: a.px10),

            _buildItemView('退出当前账号', '', _onPressedLogout),
          ],
        ),
      ),
    );
  }

  _buildItemView(leftText, rightText, onPressed){
    return GestureDetector(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: a.px16, vertical: a.px16),
        color: Colors.white,
        child: Row(
          children: <Widget>[
            Text(leftText, style: TextStyle(fontSize: a.px16),),
            Utils.expanded(),
            Text(rightText, style: TextStyle(fontSize: a.px16),),
            forwardIcon,
          ],
        ),
      ),
      onTap: onPressed,
    );
  }

  _onPressedModifyAddress() {

  }

  _onPressedModifyBankCard() {

  }

  _onPressedBindPhone() {

  }

  _onPressedModifyPasswork() {

  }

  _onPressedLogout() async{
    bool confirm = await Utils.showConfirmOptionsDialog(tips: '退出当前账号');
    if(!confirm)
      return;

    await AccountData.getInstance().clear();
    Utils.navigatePopAll();
  }
}
