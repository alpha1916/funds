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

  @override
  Widget build(BuildContext context) {
    if(Global.debug){
      phoneController.text = '18612345699';
      passController.text = '123456';
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
                TextInputType.text,
                '11位手机号码',
                false,
                Icon(Icons.phone),
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
    if( captchaController.approved() &&
        phoneController.approved() &&
        passController.approved()
    ){
      final result = await LoginRequest.register(phoneController.text, passController.text, captchaController.text);
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
    });
  }

  _onPressedGetCaptcha() async {
    if (!phoneController.approved()) {
      return Future.value(false);
    }

    final ResultData result = await HttpRequest.getPhoneCaptcha(CaptchaType.register, phoneController.text);
    if(result.success){
      captchaController.text = result.data;
      alert('验证码已发送');
    }

    return Future.value(result.success);
  }
}

