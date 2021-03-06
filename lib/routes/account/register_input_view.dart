import 'package:flutter/material.dart';
import 'dart:async';
import 'package:funds/common/constants.dart';
import 'package:funds/common/utils.dart';
import 'package:funds/network/http_request.dart';
import 'login_page.dart';

class RegisterInputView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => RegisterInputViewState();
}

class RegisterInputViewState extends State<RegisterInputView> {
  final CustomTextEditingController phoneController = CustomTextEditingController.buildPhoneEditingController();
  final CustomTextEditingController captchaController = CustomTextEditingController.buildCaptchaEditingController();
  final CustomTextEditingController passController = CustomTextEditingController.buildPasswordEditingController();
  final CustomTextEditingController inviteController = CustomTextEditingController.buildInviteCodeEditingController();

  @override
  Widget build(BuildContext context) {
    if(Global.debug){
//      phoneController.text = Global.testPhoneNumber;
      passController.text = Global.testPwd;
    }
    return Column(
      children: <Widget>[
        SizedBox(
          height: 10,
        ),
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
              buildTextFiled(
                inviteController,
                TextInputType.text,
                '请输入邀请码',
                false,
                Icon(Icons.insert_invitation),
              ),
              Divider(height: a.px1, indent: 10, color: Colors.black12),
              buildCaptchaTextFiled(captchaController, _onPressedGetCaptcha),
              Divider(height: a.px1, indent: 10, color: Colors.black12),
              buildTextFiled(
                passController,
                TextInputType.text,
                '设置登录密码',
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
        Utils.buildRaisedButton(title: '完成', onPressed: _onPressedRegister)
      ],
    );
  }

  _onPressedRegister() async {
    if( phoneController.approved() &&
        inviteController.approved() &&
        captchaController.approved() &&
        passController.approved()
    ){
      print(inviteController.text);
      final result = await LoginRequest.register(phoneController.text, passController.text, captchaController.text, inviteController.text);
      if(result.success){
        Utils.login(phoneController.text, passController.text);
      }
    }
  }
  
  onTextClear() {
    setState(() {
      phoneController.clear();
      passController.clear();
      captchaController.clear();
      inviteController.clear();
    });
  }

  _onPressedGetCaptcha() async {
    if (!phoneController.approved()) {
      return Future.value(false);
    }

    final ResultData result = await HttpRequest.getPhoneCaptcha(CaptchaType.register, phoneController.text);
    if(result.success){
//      captchaController.text = result.data;
      alert('验证码已发送');
    }

    return Future.value(result.success);
  }
}

