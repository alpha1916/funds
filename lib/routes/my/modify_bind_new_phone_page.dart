import 'package:flutter/material.dart';
import 'package:funds/common/constants.dart';
import 'package:funds/common/utils.dart';
import 'package:funds/common/widgets/phone_captcha_button.dart';
import 'package:funds/model/account_data.dart';
import 'package:funds/network/http_request.dart';
import 'package:funds/network/user_request.dart';

class BindNewPhonePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var fontSize = a.px16;
    return Scaffold(
      appBar: AppBar(
        title:Text('修改绑定手机'),
      ),
      body: Container(
        color: CustomColors.background1,
        child: Column(
          children: <Widget>[
            _buildPhoneView(fontSize),
            Utils.buildSplitLine(),
            _buildCaptchaView(),
            SizedBox(height: a.px50),
            Utils.buildRaisedButton(title: '下一步', onPressed: _onPressedNext),
          ],
        ),
      ),
    );
  }

  _buildPhoneView(fontSize){
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: a.px20, vertical: a.px1),
      child: Row(
        children: <Widget>[
          Text('新绑定手机', style: TextStyle(fontSize: fontSize),),
          SizedBox(width: a.px20),
          Expanded(
            child: TextField(
              controller: phoneController,
              keyboardType: TextInputType.number,
              cursorColor: Colors.black12,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: '请输入新手机号码',
                labelStyle: TextStyle(fontSize: 20),
              ),
              autofocus: false,
            ),
          ),
        ],
      ),
    );
  }

  final TextEditingController captchaController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  _buildCaptchaView(){
    return Container(
      padding: EdgeInsets.only(left: a.px20, top: a.px3, bottom: a.px3),
      color: Colors.white,
      child: Row(
        children: <Widget>[
          Text('短信验证码', style: TextStyle(fontSize: a.px16),),
          SizedBox(width: a.px20),
          Expanded(
            child: TextField(
              controller: captchaController,
              keyboardType: TextInputType.number,
              cursorColor: Colors.black12,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: '验证码',
                labelStyle: TextStyle(fontSize: 20),
              ),
              autofocus: false,
            ),
          ),
          PhoneCaptchaButton(_onPressedGetCaptcha),
        ],
      ),
    );
  }

  _onPressedGetCaptcha() async {
    if (!Utils.isValidPhoneNumber(phoneController.text)) {
      alert('请输入正确的手机号码');
      return Future.value(false);
    }

    final ResultData result = await HttpRequest.getPhoneCaptcha(CaptchaType.newPhone, phoneController.text);
    if(result.success){
      captchaController.text = result.data;
      alert('验证码已发送');
    }

    return Future.value(result.success);
  }

  _onPressedNext() async {
    if (!Utils.isValidPhoneNumber(phoneController.text)) {
      alert('请输入正确的手机号码');
    }else if(captchaController.text.length == 0){
      alert('请输入验证码');
    }else {
      ResultData result = await UserRequest.modifyBindPhone(phoneController.text, captchaController.text);
      if(result.success){
        await alert('绑定新手机成功');
        await UserRequest.getUserInfo();
        Utils.navigatePopAll(AppTabIndex.my);
      }
    }
  }
}
