import 'package:flutter/material.dart';
import 'package:funds/common/constants.dart';
import 'package:funds/common/utils.dart';
import 'package:funds/network/http_request.dart';
import 'dart:async';
import 'package:funds/common/widgets/phone_captcha_button.dart';

class ForgetPasswordPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if(Global.debug){
      passController1.text = '123456';
      passController2.text = '123456';
      phoneController.text = '18612345699';
    }
    return Scaffold(
      appBar: AppBar(
        title:Text('忘记密码'),
      ),
      body: Container(
        color: CustomColors.background1,
        child: Column(
          children: <Widget>[
            SizedBox(height: a.px20),
            _buildTextFiled(
              phoneController,
              TextInputType.text,
              '11位手机号码',
              false,
              Container(
                margin: EdgeInsets.only(left: a.px5),
                child: Icon(Icons.phone),
              ),
            ),
            Utils.buildSplitLine(margin: EdgeInsets.only(left: a.px10)),
            _buildCaptchaTextFiled(context),
            Utils.buildSplitLine(margin: EdgeInsets.only(left: a.px10)),
            _buildTextFiled(
              passController1,
              TextInputType.text,
              '请设置新密码',
              true,
              Container(
                margin: EdgeInsets.only(left: a.px5),
                child: Icon(Icons.lock),
              ),
            ),
            Utils.buildSplitLine(margin: EdgeInsets.only(left: a.px10)),

            _buildTextFiled(
              passController2,
              TextInputType.text,
              '请再次输入',
              true,
              Container(
                margin: EdgeInsets.only(left: a.px5),
                child: Icon(Icons.lock),
              ),
            ),

            Container(
              margin: EdgeInsets.only(top: 10, left: 55),
              child: Row(
                children: <Widget>[
                  Text('登录密码由6-16位数字和字母组成'),
                  Expanded(child: Container(),),
                ],
              ),
            ),

            Container(
              margin: EdgeInsets.only(top: a.px20, bottom: a.px10),
              width: a.px(200),
              height: a.px48,
              child: RaisedButton(
                child: Text(
                  '确定',
                  style: TextStyle(color: Colors.white, fontSize: a.px18),
                ),
                onPressed: _onPressedOK,
                color: Colors.black,
                shape: StadiumBorder(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  final CustomTextEditingController phoneController = CustomTextEditingController.buildPhoneEditingController();
  final CustomTextEditingController captchaController = CustomTextEditingController.buildCaptchaEditingController();
  final CustomTextEditingController passController1 = CustomTextEditingController.buildPasswordEditingController();
  final CustomTextEditingController passController2 = CustomTextEditingController.buildPasswordEditingController();

  _buildTextFiled(controller, keyboardType, labelText, obscureText, icon) {
    return Container(
      padding: EdgeInsets.only(left: a.px10, top: a.px1),
      color: Colors.white,
      child: Row(
        children: <Widget>[
          icon,
          Container(
            margin: EdgeInsets.only(left: a.px10),
            width: a.px(300),
            child:TextField(
              controller: controller,
              keyboardType: keyboardType,
              cursorColor: Colors.black12,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: labelText,
                labelStyle: TextStyle(fontSize: a.px20),
              ),
              autofocus: false,
              obscureText: obscureText,
            ),
          )
        ],
      ),
    );
  }

  _buildCaptchaTextFiled(context) {
    return Container(
      padding: EdgeInsets.only(left: a.px16, top: a.px1),
      color: Colors.white,
      child: Row(
        children: <Widget>[
          Icon(Icons.perm_phone_msg),
          SizedBox(width: a.px10),
          Expanded(
            child: TextField(
              controller: captchaController,
              cursorColor: Colors.black12,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: '手机验证码',
                labelStyle: TextStyle(fontSize: a.px20),
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
    if(!phoneController.approved()){
      return Future.value(false);
//    if (!Utils.isValidPhoneNumber(phoneController.text)) {
//      alert('请输入正确的手机号码');
//      return Future.value(false);
    }

    final ResultData result = await HttpRequest.getPhoneCaptcha(CaptchaType.forgotPassword, phoneController.text);
    if(result.success){
      captchaController.text = result.data;
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

//    if(passController1.approved())
//      return;
//
//    if(captchaController.text.length == 0){
//      alert('请输入验证码');
//    } else  else if (!Utils.isValidPhoneNumber(phoneController.text)) {
//      alert('请输入正确的手机号码');
//    } else if (!Utils.isValidPassword(passController1.text)) {
//      alert('密码必须为6-16位字母和数字组成');
//    }else{
//      final ResultData result = await LoginRequest.setNewPassword(phoneController.text, passController1.text, captchaController.text);
//      if(result.success){
//        await alert('新密码设置成功');
//        Utils.navigatePop();
//      }
//    }
  }
}
