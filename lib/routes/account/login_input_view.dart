import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:funds/common/constants.dart';
import 'package:funds/common/utils.dart';
import 'package:funds/network/http_request.dart';
import 'forget_password_page.dart';

class LoginInputView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => LoginInputViewState();
}

class LoginInputViewState extends State<LoginInputView> {
  //手机号的控制器
//  TextEditingController phoneController = TextEditingController();

  //密码的控制器
//  TextEditingController passController = TextEditingController();

  final CustomTextEditingController phoneController = CustomTextEditingController.buildPhoneEditingController();
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

  @override
  Widget build(BuildContext context) {
    if(Global.debug){
      phoneController.text = '18612345672';
      passController.text = '123456';
    }

    return Container(
      child: Column(
        children: <Widget>[
          SizedBox(height: 10,),
          _buildTextFiled(phoneController, TextInputType.number, '11位手机号码', false,
            Container(
              margin: EdgeInsets.only(left: 5),
              child: Icon(Icons.phone),
            ),
          ),
          Utils.buildSplitLine(margin: EdgeInsets.only(left: 10), color: Colors.black12),
          _buildTextFiled(passController, TextInputType.text, '请输入登录密码', true,
            Container(
              margin: EdgeInsets.only(left: 5),
              child: Icon(Icons.lock),
            ),
          ),

          Container(
            margin: EdgeInsets.only(top: 20, bottom: 10),
            width: 180,
            height: 48,
            child: RaisedButton(
              child: Text(
                '登录',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              onPressed: _onPressedLogin,
              color: Colors.black,
              shape: StadiumBorder(),
            ),
          ),
          FlatButton(
            child: Text('忘记密码', style: TextStyle(fontSize: 15),),
            onPressed: _onPressedForget,
          )
        ],
      ),
    );
  }

  _onPressedForget() {
    Utils.navigateTo(ForgetPasswordPage());
  }

  _isValidPhoneNumber(String str) {
    return str.length == 11;
//    return RegExp(r'^((13[0-9])|(14[0-9])|(15[0-9])|(16[0-9])|(17[0-9])|(18[0-9])|(19[0-9]))\d{8}$').hasMatch(str);
  }

  _isValidPassword(String str) {
//    final exp = r'^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{6,16}$';
    final exp = r'^[a-zA-Z0-9]{6,16}$';
    return RegExp(exp).hasMatch(str);
  }

  void _onPressedLogin() async {
    print({'phone': phoneController.text, 'password': passController.text});
    if (!_isValidPhoneNumber(phoneController.text)) {
      alert('请输入正确的手机号码');
    } else if (!_isValidPassword(passController.text)) {
      alert('密码必须为6-16位字母和数字组成');
    } else {
      Utils.login(phoneController.text, passController.text);
    }
  }

  void onTextClear() {
    setState(() {
      phoneController.clear();
      passController.clear();
    });
  }
}