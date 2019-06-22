import 'package:flutter/material.dart';
import 'package:funds/common/constants.dart';
import 'package:funds/common/utils.dart';
import 'package:funds/common/widgets/phone_captcha_button.dart';
import 'package:funds/network/http_request.dart';
import 'package:funds/network/user_request.dart';

class CertificationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:Text('实名认证'),
      ),
      body: Container(
        color: CustomColors.background1,
        child: Column(
          children: <Widget>[
            _buildItemView('真实姓名',  nameController),
            Utils.buildSplitLine(),
            SizedBox(height: a.px50),
            Utils.buildRaisedButton(title: '确认', onPressed: _onPressedOK),
          ],
        ),
      ),
    );
  }

  final TextEditingController nameController = TextEditingController();
  _buildItemView(title, controller){
    return Container(
      padding: EdgeInsets.only(left: a.px20, top: a.px3, bottom: a.px3),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(title, style: TextStyle(fontSize: a.px16),),
          Expanded(
            child: TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              cursorColor: Colors.black12,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: '验证码',
                labelStyle: TextStyle(fontSize: 20),
              ),
              autofocus: false,
            ),
          ),
        ],
      ),
    );
  }

  _onPressedOK() {

  }
}
