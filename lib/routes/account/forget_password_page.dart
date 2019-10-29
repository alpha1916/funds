import 'package:flutter/material.dart';
import 'package:funds/common/constants.dart';
import 'package:funds/common/utils.dart';
import 'package:funds/network/http_request.dart';
import 'dart:async';
import 'login_page.dart';

class ForgetPasswordPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
//    if(Global.debug){
//      passController1.text = Global.testPwd;
//      passController2.text = Global.testPwd;
//      phoneController.text = Global.testPhoneNumber;
//    }
    return Scaffold(
      appBar: AppBar(
        title:Text('忘记密码'),
      ),
      body: InkWell(
        child: Column(
          children: <Widget>[
            SizedBox(height: a.px20),
            Container(
              color: Colors.white,
              child: Column(
                children: <Widget>[
                  buildTextFiled(
                    phoneController,
                    TextInputType.number,
                    '11位手机号码',
                    false,
                    Icon(Icons.phone),
                  ),
                  Divider(height: a.px1, indent: a.px16),
                  buildCaptchaTextFiled(captchaController, _onPressedGetCaptcha),
                  Divider(height: a.px1, indent: a.px16),
                  buildTextFiled(
                    passController1,
                    TextInputType.text,
                    '请设置新密码',
                    true,
                    Icon(Icons.lock),
                  ),
                  Divider(height: a.px1, indent: a.px16),
                  buildTextFiled(
                    passController2,
                    TextInputType.text,
                    '请再次输入',
                    true,
                    Icon(Icons.lock),
                  ),
                ],
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.only(top: 10, left: 20),
              child: Text('登录密码由6-16位数字和字母组成'),
            ),
            Utils.buildRaisedButton(title: '确定', onPressed: _onPressedOK)
          ],
        ),
        onTap: () {
          FocusScope.of(context).unfocus();
        },
      )
    );
  }

  final CustomTextEditingController phoneController = CustomTextEditingController.buildPhoneEditingController();
  final CustomTextEditingController captchaController = CustomTextEditingController.buildCaptchaEditingController();
  final CustomTextEditingController passController1 = CustomTextEditingController.buildPasswordEditingController();
  final CustomTextEditingController passController2 = CustomTextEditingController.buildPasswordEditingController();

  _onPressedGetCaptcha() async {
    if(!phoneController.approved()){
      return Future.value(false);
    }

    final ResultData result = await HttpRequest.getPhoneCaptcha(CaptchaType.forgotPassword, phoneController.text);
    if(result.success){
//      captchaController.text = result.data;
      alert('验证码已发送');
    }
    return Future.value(result.success);
  }

  _onPressedOK() async{
    if( captchaController.approved() &&
        phoneController.approved() &&
        passController1.approved()
    ){
      if(passController1.text != passController2.text){
        alert('两次输入的密码不一致');
        return;
      }

      final ResultData result = await LoginRequest.setNewPassword(phoneController.text, passController1.text, captchaController.text);
      if(result.success){
        await alert('新密码设置成功');
        Utils.navigatePop();
      }
    }
  }
}
