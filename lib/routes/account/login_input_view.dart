import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:funds/common/constants.dart';
import 'package:funds/common/utils.dart';
import 'forget_password_page.dart';
import 'login_page.dart';

class LoginInputView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => LoginInputViewState();
}

class LoginInputViewState extends State<LoginInputView> {
  final CustomTextEditingController phoneController = CustomTextEditingController.buildPhoneEditingController();
  final CustomTextEditingController passController = CustomTextEditingController.buildPasswordEditingController();

  @override
  void dispose() {
    super.dispose();
    phoneController.dispose();
    passController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if(Global.debug){
      phoneController.text = Global.testPhoneNumber;
      passController.text = Global.testPwd;
    }

    return Column(
        children: <Widget>[
          SizedBox(height: 10,),
          Container(
            color: Colors.white,
            child: Column(
              children: <Widget>[
                buildTextFiled(phoneController, TextInputType.number, '11位手机号码', false,Icon(Icons.phone)),
                Divider(height: a.px1, indent: a.px10, color: Colors.black12),
                buildTextFiled(passController, TextInputType.text, '请输入登录密码', true, Icon(Icons.lock),
                ),
              ],
            ),
          ),
          Utils.buildRaisedButton(title: '登录', onPressed: _onPressedLogin),
          FlatButton(
            child: Text('忘记密码', style: TextStyle(fontSize: a.px15),),
            onPressed: _onPressedForget,
          )
        ],
    );
  }

  _onPressedForget() {
    Utils.navigateTo(ForgetPasswordPage());
  }

  void _onPressedLogin() async {
    if(phoneController.approved() && passController.approved()){
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