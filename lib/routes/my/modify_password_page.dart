import 'package:flutter/material.dart';
import 'package:funds/common/constants.dart';
import 'package:funds/common/utils.dart';
import 'package:funds/network/http_request.dart';
import 'package:funds/routes/account/forget_password_page.dart';

class ModifyPasswordPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if(Global.debug){
      oldController.text = '123456789';
      passController1.text = '123456';
      passController2.text = '123456';
    }
    return Scaffold(
      appBar: AppBar(
        title:Text('修改登录密码'),
      ),
      body: Column(
        children: <Widget>[
          SizedBox(height: a.px20),
          _buildTextFiled('原登录密码', oldController, '请输入旧密码'),
          Utils.buildSplitLine(margin: EdgeInsets.only(left: a.px10)),
          _buildTextFiled('新登录密码', passController1, '请设置新密码'),
          Utils.buildSplitLine(margin: EdgeInsets.only(left: a.px10)),
          _buildTextFiled('确认新密码', passController2, '请再次输入新密码'),

          Container(
            margin: EdgeInsets.only(top: a.px10, left: a.px16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text('登录密码由6-16位数字和字母组成'),
            ),
          ),

          Container(
            margin: EdgeInsets.only(top: a.px20, bottom: a.px10),
            width: a.px(200),
            height: a.px48,
            child: RaisedButton(
              child: Text(
                '确定修改',
                style: TextStyle(color: Colors.white, fontSize: a.px18),
              ),
              onPressed: _onPressedOK,
              color: Colors.black,
              shape: StadiumBorder(),
            ),
          ),
          FlatButton(
            child: Text('忘记密码', style: TextStyle(fontSize: 15, decoration: TextDecoration.underline),),
            onPressed: _onPressedForget,
          )
        ],
      ),
      resizeToAvoidBottomPadding: false,
    );
  }

  final CustomTextEditingController oldController = CustomTextEditingController.buildPasswordEditingController();
  final CustomTextEditingController passController1 = CustomTextEditingController.buildPasswordEditingController();
  final CustomTextEditingController passController2 = CustomTextEditingController.buildPasswordEditingController();

  _buildTextFiled(title, controller, hintText) {
    return Container(
      padding: EdgeInsets.only(left: a.px16, right: a.px16, top: a.px1),
      color: Colors.white,
      child: Row(
        children: <Widget>[
          Text(title, style: TextStyle(fontSize: a.px16, fontWeight: FontWeight.w500),),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(left: a.px30),
              child:TextField(
                controller: controller,
                cursorColor: Colors.black12,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: hintText,
                  labelStyle: TextStyle(fontSize: a.px20),
                ),
                autofocus: false,
                obscureText: true,
              ),
            ),
          ),

        ],
      ),
    );
  }

  _onPressedOK() async{
    if(passController1.text != passController2.text){
      alert('两次输入的新密码不一致');
    } else if (passController1.approved()) {
      final ResultData result = await LoginRequest.modifyPassword(oldController.text, passController1.text);
      if(result.success){
        await alert('新密码设置成功');
        Utils.navigatePop();
      }
    }
  }

  _onPressedForget() {
    Utils.navigateTo(ForgetPasswordPage());
  }
}
