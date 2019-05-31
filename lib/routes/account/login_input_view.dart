import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:funds/common/constants.dart';

class LoginInputView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => LoginInputViewState();
}

class LoginInputViewState extends State<LoginInputView> {
  //手机号的控制器
  TextEditingController phoneController = TextEditingController();

  //密码的控制器
  TextEditingController passController = TextEditingController();

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

  @override
  Widget build(BuildContext context) {
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
          _buildTextFiled(passController, TextInputType.text, '请输入登录密码', false,
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
    print('press forget');
  }

  alert (context, tips) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Center(child: Text(tips, textAlign: TextAlign.center,)),
          titleTextStyle:TextStyle(fontSize: 16, color: Colors.white),
          backgroundColor: Colors.black87,
        )
    );
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

  void _onPressedLogin() {
    print({'phone': phoneController.text, 'password': passController.text});
    if (!_isValidPhoneNumber(phoneController.text)) {
      alert(context, '请输入正确的手机号码');
    } else if (!_isValidPassword(passController.text)) {
      alert(context, '密码必须为6-16位字母和数字组成');
    } else {
      alert(context, '登录成功');
//      phoneController.clear();
    }
  }

  void onTextClear() {
    setState(() {
      phoneController.clear();
      passController.clear();
    });
  }
}