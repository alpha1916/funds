import 'package:flutter/material.dart';
import 'package:funds/common/constants.dart';
import 'package:funds/common/utils.dart';
import 'package:funds/network/user_request.dart';

class CertificationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if(Global.debug){
      nameController.text = '孙悟空';
      idController.text = '140400199709307098';
    }
    return Scaffold(
      appBar: AppBar(
        title:Text('实名认证'),
      ),
      body:Column(
        children: <Widget>[
          _buildItemView('真实姓名', nameController, '请输入您的姓名'),
          Divider(height: 1),
          _buildItemView('身份证号', idController, '18位身份证号'),
          _buildTipsView(),
          SizedBox(height: a.px50),
          Utils.buildRaisedButton(title: '确认', onPressed: _onPressedOK),
        ],
      ),
      resizeToAvoidBottomPadding: false,
    );
  }

  _buildTipsView() {
    return Container(
        padding: EdgeInsets.only(left: a.px20, top: a.px12),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text('请填写与银行卡开户人一致的身份信息', style: TextStyle(fontSize: a.px16, fontWeight: FontWeight.w500),),
        )
    );
  }

  final CustomTextEditingController nameController = CustomTextEditingController.buildNameEditingController();
  final CustomTextEditingController idController = CustomTextEditingController.buildIDEditingController();
  _buildItemView(title, controller, hintText){
    return Container(
      padding: EdgeInsets.only(left: a.px20, top: a.px3, bottom: a.px3),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(title, style: TextStyle(fontSize: a.px16),),
          SizedBox(width: a.px30),
          Expanded(
            child: TextField(
              controller: controller,
              cursorColor: Colors.black12,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: hintText,
                labelStyle: TextStyle(fontSize: 20),
              ),
              autofocus: false,
            ),
          ),
        ],
      ),
    );
  }

  _onPressedOK() async{
    if(nameController.approved() && idController.approved()){
      var result = await UserRequest.certificate(nameController.text, idController.text);
      if(result.success){
        await alert('实名认证成功');
        Utils.navigatePop(true);
      }
    }
  }
}
