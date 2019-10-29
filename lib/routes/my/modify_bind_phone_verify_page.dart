import 'package:flutter/material.dart';
import 'package:funds/common/constants.dart';
import 'package:funds/common/utils.dart';
import 'package:funds/common/widgets/phone_captcha_button.dart';
import 'package:funds/model/account_data.dart';
import 'package:funds/network/http_request.dart';
import 'package:funds/network/user_request.dart';
import 'modify_bind_new_phone_page.dart';

class ModifyPhoneVerifyPage extends StatelessWidget {
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
      padding: EdgeInsets.symmetric(horizontal: a.px20, vertical: a.px16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text('原绑定手机', style: TextStyle(fontSize: fontSize),),
          Text(Utils.getObscurePhoneNumber(), style: TextStyle(fontSize: fontSize),),
        ],
      ),
    );
  }

  final TextEditingController captchaController = TextEditingController();
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
    final ResultData result = await HttpRequest.getPhoneCaptcha(CaptchaType.oldPhone, AccountData.getInstance().phone);
    if(result.success){
//      captchaController.text = result.data;
      alert('验证码已发送');
    }

    return Future.value(result.success);
  }

  _onPressedNext() async {
    if(captchaController.text.length == 0){
      alert('请填写手机验证码');
      return;
    }
    ResultData result = await UserRequest.verifyOldPhone(AccountData.getInstance().phone, captchaController.text);
    if(result.success){
      Utils.navigateTo(BindNewPhonePage());
    }
  }
}
