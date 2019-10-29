import 'package:flutter/material.dart';
import 'package:funds/common/constants.dart';
import 'package:funds/common/utils.dart';
import 'package:funds/common/widgets/phone_captcha_button.dart';
import 'package:funds/network/http_request.dart';
import 'package:funds/network/user_request.dart';

class BindNewPhonePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var fontSize = a.px16;
    return Scaffold(
      appBar: AppBar(
        title:Text('修改绑定手机'),
      ),
      body: Column(
        children: <Widget>[
          _buildPhoneView(fontSize),
          Divider(height: 1),
          _buildCaptchaView(),
          SizedBox(height: a.px50),
          Utils.buildRaisedButton(title: '下一步', onPressed: _onPressedNext),
        ],
      ),
      resizeToAvoidBottomPadding: false,
    );
  }

  _buildPhoneView(fontSize){
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: a.px20, vertical: a.px1),
      child: Row(
        children: <Widget>[
          Text('新绑定手机', style: TextStyle(fontSize: fontSize),),
          SizedBox(width: a.px20),
          Expanded(
            child: TextField(
              controller: phoneController,
              cursorColor: Colors.black12,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: '请输入新手机号码',
                labelStyle: TextStyle(fontSize: a.px20),
              ),
              autofocus: false,
            ),
          ),
        ],
      ),
    );
  }

  final CustomTextEditingController phoneController = CustomTextEditingController.buildPhoneEditingController();
  final CustomTextEditingController captchaController = CustomTextEditingController.buildCaptchaEditingController();
  _buildCaptchaView(){
    return Container(
      padding: EdgeInsets.only(left: a.px20, top: a.px3, bottom: a.px3),
      color: Colors.white,
      child: Row(
        children: <Widget>[
          Text('短信验证码', style: TextStyle(fontSize: a.px16),),
          SizedBox(width: a.px20),
          Expanded(
            child: TextField(
              controller: captchaController,
              cursorColor: Colors.black12,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: '验证码',
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
    if (!phoneController.approved()) {
      return Future.value(false);
    }

    final ResultData result = await HttpRequest.getPhoneCaptcha(CaptchaType.newPhone, phoneController.text);
    if(result.success){
//      captchaController.text = result.data;
      alert('验证码已发送');
    }

    return Future.value(result.success);
  }

  _onPressedNext() async {
    if (phoneController.approved() && captchaController.approved()) {
      ResultData result = await UserRequest.modifyBindPhone(phoneController.text, captchaController.text);
      if(result.success){
        await alert('绑定新手机成功');
        await UserRequest.getUserInfo();
        Utils.navigatePopAll(AppTabIndex.my);
      }
    }
  }
}
