//import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:funds/common/constants.dart';
import 'package:funds/common/utils.dart';
import 'package:funds/network/http_request.dart';


class RegisterInputView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => RegisterInputViewState();
}

class RegisterInputViewState extends State<RegisterInputView> {
  //手机号的控制器
  TextEditingController phoneController = TextEditingController();

  //密码的控制器
  TextEditingController passController = TextEditingController();

  //验证码的控制器
  TextEditingController captchaController = TextEditingController();

  _buildTextFiled(controller, keyboardType, labelText, obscureText, icon) {
    return Container(
      margin: EdgeInsets.only(top: 1),
      color: Colors.white,
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        cursorColor: Colors.black12,
        decoration: InputDecoration(
          //                contentPadding: EdgeInsets.all(10),
          border: InputBorder.none,
          icon: Container(
            margin: EdgeInsets.only(left: 10),
            child: icon,
          ),
          hintText: labelText,
          labelStyle: TextStyle(fontSize: 20),
        ),
        autofocus: false,
        obscureText: obscureText,
      ),
    );
  }

  _buildCaptchaTextFiled() {
    return Container(
      margin: EdgeInsets.only(top: 1),
      color: Colors.white,
      child: Row(
//        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Expanded(
            child: TextField(
              controller: captchaController,
              keyboardType: TextInputType.number,
              cursorColor: Colors.black12,
              decoration: InputDecoration(
                border: InputBorder.none,
                icon: Container(
                  margin: EdgeInsets.only(left: 10),
                  child: Container(
                    margin: EdgeInsets.only(left: 5),
                    child: Icon(Icons.perm_phone_msg),
                  ),
                ),
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
    phoneController.text = '18612345671';
    passController.text = '123456';
    return Container(
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 10,
          ),
          _buildTextFiled(
            phoneController,
            TextInputType.number,
            '11位手机号码',
            false,
            Container(
              margin: EdgeInsets.only(left: 5),
              child: Icon(Icons.phone),
            ),
          ),
          _buildCaptchaTextFiled(),
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
            margin: EdgeInsets.only(top: 10, left: 55),
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

  _isValidPhoneNumber(String str) {
    return str.length == 11;
//    return RegExp(r'^((13[0-9])|(14[0-9])|(15[0-9])|(16[0-9])|(17[0-9])|(18[0-9])|(19[0-9]))\d{8}$').hasMatch(str);
  }

  _isValidPassword(String str) {
    final exp = r'^[a-zA-Z0-9]{6,16}$';
    return RegExp(exp).hasMatch(str);
  }

  _onPressedRegister() async {
    print({'phone': phoneController.text, 'password': passController.text});
    if (!_isValidPhoneNumber(phoneController.text)) {
      alert('请输入正确的手机号码');
    } else if (!_isValidPassword(passController.text)) {
      alert('密码必须为6-16位字母和数字组成');
    } else {
//      alert(context, '登录成功');
//      phoneController.clear();
      final result = await LoginRequest.register(phoneController.text, passController.text, captchaController.text);
      if(result.success){
        _login();
      }
    }
  }
  
  _login() async {
    final ResultData result = await LoginRequest.login(phoneController.text, passController.text);
    if(result.success){
      Utils.navigatePopAll();
    }
  }

  onTextClear() {
    setState(() {
      phoneController.clear();
      passController.clear();
      captchaController.clear();
    });
  }

//  _sendGetCaptcha() async {
////    await Future.delayed(Duration(seconds: 1));
////    return {'success':false};
//    if (!_isValidPhoneNumber(phoneController.text)) {
//      alert('请输入正确的手机号码');
//      return;
//    }
//
//    final ResultData result = await AccountRequest.getPhoneCaptcha(phoneController.text);
//    if(result.success){
//      captchaController.text = result.data;
//    }
//  }

  _onPressedGetCaptcha() async {
    if (!_isValidPhoneNumber(phoneController.text)) {
      alert('请输入正确的手机号码');
      return Future.value(false);
    }

    final ResultData result = await LoginRequest.getPhoneCaptcha(phoneController.text);
    if(result.success){
      captchaController.text = result.data;
    }
//    var result = await _sendGetCaptcha();
//    alert('发送失败');

    return Future.value(result.success);
  }
}

class PhoneCaptchaButton extends StatefulWidget {
  final onPressed;
  PhoneCaptchaButton(this.onPressed);
  @override
  _PhoneCaptchaButtonState createState() => _PhoneCaptchaButtonState(onPressed);
}

class _PhoneCaptchaButtonState extends State<PhoneCaptchaButton> {
  final onCallback;
  _PhoneCaptchaButtonState(this.onCallback);
  Timer _countdownTimer;
  final int cd = 15;
  String title = '短信验证';
  var _onPressed;

   countdown() async {
     setState(() {
       _onPressed = null;
     });

    bool success = await onCallback();
    if(!success){
      setState(() {
        _onPressed = countdown;
      });
      return;
    }

    _countdownTimer =  new Timer.periodic(new Duration(seconds: 1), (timer) {
      setState(() {
        if(_countdownTimer.tick < cd){
          title = '${cd - _countdownTimer.tick}s后重发';
          _onPressed = null;
        }else{
          _countdownTimer.cancel();
          _countdownTimer = null;
          title = '重新发送';
          _onPressed = countdown;
        }
      });
    });

    setState(() {
      title = '${cd}s后重发';
      _onPressed = null;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _onPressed = countdown;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _countdownTimer?.cancel();
    _countdownTimer = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      child: RaisedButton(
        child: Text(
          title,
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        onPressed: _onPressed,
        color: Colors.black,
      ),
    );
  }
}
