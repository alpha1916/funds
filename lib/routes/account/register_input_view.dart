import 'package:flutter/material.dart';
import 'dart:async';
import 'package:funds/common/constants.dart';
import 'package:funds/common/utils.dart';
import 'package:funds/common/widgets/phone_captcha_button.dart';
import 'package:funds/network/http_request.dart';

class RegisterInputView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => RegisterInputViewState();
}

class RegisterInputViewState extends State<RegisterInputView> {
  //手机号的控制器
//  TextEditingController phoneController = TextEditingController();
//
//  //密码的控制器
//  TextEditingController passController = TextEditingController();
//
//  //验证码的控制器
//  TextEditingController captchaController = TextEditingController();

  final CustomTextEditingController phoneController = CustomTextEditingController.buildPhoneEditingController();
  final CustomTextEditingController captchaController = CustomTextEditingController.buildCaptchaEditingController();
  final CustomTextEditingController passController = CustomTextEditingController.buildPasswordEditingController();

  _buildTextFiled(controller, keyboardType, labelText, obscureText, icon) {
    return Container(
      padding: EdgeInsets.only(left: 10, top: 1),
      color: Colors.white,
      child: Row(
        children: <Widget>[
          icon,
          Container(
            margin: EdgeInsets.only(left: 10),
            width: 300,
            child:TextField(
              controller: controller,
              keyboardType: keyboardType,
              cursorColor: Colors.black12,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: labelText,
                labelStyle: TextStyle(fontSize: 20),
              ),
              autofocus: false,
              obscureText: obscureText,
            ),
          )
        ],
      ),
    );
  }

  _buildCaptchaTextFiled() {
    return Container(
      padding: EdgeInsets.only(left: 16, top: 1),
      color: Colors.white,
      child: Row(
//        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Icon(Icons.perm_phone_msg),
          SizedBox(width: 10,),
          Expanded(
            child: TextField(
              controller: captchaController,
              cursorColor: Colors.black12,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: '手机验证码',
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

  @override
  Widget build(BuildContext context) {
    if(Global.debug){
      phoneController.text = '18612345699';
      passController.text = '123456';
    }
    return Container(
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 10,
          ),
          _buildTextFiled(
            phoneController,
            TextInputType.text,
            '11位手机号码',
            false,
            Container(
              margin: EdgeInsets.only(left: 5),
              child: Icon(Icons.phone),
            ),
          ),
          Utils.buildSplitLine(margin: EdgeInsets.only(left: 10), color: Colors.black12),
          _buildCaptchaTextFiled(),
          Utils.buildSplitLine(margin: EdgeInsets.only(left: 10), color: Colors.black12),
          _buildTextFiled(
            passController,
            TextInputType.text,
            '设置登录密码',
            true,
            Container(
              margin: EdgeInsets.only(left: 5),
              child: Icon(Icons.lock),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 10, left: 20),
            child: Row(
              children: <Widget>[
                Text('登录密码由6-16位数字和字母组成'),
                Expanded(child: Container(),),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 20, bottom: 10),
            width: 180,
            height: 48,
            child: RaisedButton(
              child: Text(
                '完成',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              onPressed: _onPressedRegister,
              color: Colors.black,
              shape: StadiumBorder(),
            ),
          ),
        ],
      ),
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


//    if(captchaController.text.length == 0){
//      alert('请输入验证码');
//    }else if (!Utils.isValidPhoneNumber(phoneController.text)) {
//      alert('请输入正确的手机号码');
//    } else if (!Utils.isValidPassword(passController.text)) {
//      alert('密码必须为6-16位字母和数字组成');
//    } else {
//      final result = await LoginRequest.register(phoneController.text, passController.text, captchaController.text);
//      if(result.success){
//        Utils.login(phoneController.text, passController.text);
//      }
//    }
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
      alert('请输入正确的手机号码');
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

