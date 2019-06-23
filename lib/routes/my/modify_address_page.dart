import 'package:flutter/material.dart';
import 'package:funds/common/constants.dart';
import 'package:funds/common/utils.dart';
import 'package:funds/common/widgets/phone_captcha_button.dart';
import 'package:funds/network/http_request.dart';
import 'package:funds/network/user_request.dart';

class ModifyAddressPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
//    if(Global.debug)
//      addressController.text = '广东省广州市天河区科韵路11号';
    return Scaffold(
      appBar: AppBar(
        title:Text('修改地址'),
      ),
      body: Container(
        color: CustomColors.background1,
        child: Column(
          children: <Widget>[
            _buildLocationView(),
            Utils.buildRaisedButton(title: '确定', onPressed: _onPressedOK),
          ],
        ),
      ),
      resizeToAvoidBottomPadding: false,
    );
  }

  final TextEditingController addressController = TextEditingController();
  _buildLocationView(){
    addressController.text = AccountData.getInstance().address;
    return Container(
      padding: EdgeInsets.only(left: a.px16, top: a.px3, bottom: a.px3),
      color: Colors.white,
      child: Row(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: a.px3),
            child: Column(
              children: <Widget>[
                Text('联系地址', style: TextStyle(fontSize: a.px16),),
                Text('', style: TextStyle(fontSize: a.px16),),
              ],
            ),
          ),
          SizedBox(width: a.px20),
          Expanded(
            child: TextField(
              controller: addressController,
              cursorColor: Colors.black12,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: '请输入详细地址',
                labelStyle: TextStyle(fontSize: a.px16),
              ),
              autofocus: false,
              maxLines: 2,
              style: TextStyle(fontSize: a.px16),
            ),
          ),
          SizedBox(width: a.px16),
        ],
      ),
    );
  }

  _onPressedOK() {

  }
}

