import 'package:flutter/material.dart';
import 'package:funds/common/constants.dart';
import 'package:funds/common/utils.dart';

import 'package:flutter/services.dart' show rootBundle;
import 'dart:typed_data';
import 'package:image_picker_saver/image_picker_saver.dart';
import 'package:permission_handler/permission_handler.dart';


class ConcernWXPage extends StatelessWidget {
  final tips = '关注方式：\n\n1. 长按二维码保存本地后，打开微信扫描读取二维码图片即可关注"${Global.wxName}〃官方微信公众号。\n\n2. 登录微信，搜索"${Global.wxName}〃微信公众号并关注。';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:Text('关注微信'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(height: a.px50),
            InkWell(
              child: Image.asset(CustomIcons.wxQRCode, width: a.px(280), fit: BoxFit.fill,),
              onLongPress: _savedImage,
//              onTap: _savedImage,
            ),
            SizedBox(height: a.px50),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: a.px16),
              child: Text(tips, style: TextStyle(fontSize: a.px16),),
            )
          ],
        ),
      ),
    );
  }

  _savedImage() async {
    ByteData bytes = await rootBundle.load(CustomIcons.wxQRCode);
    var result = await ImagePickerSaver.saveFile(fileData: bytes.buffer.asUint8List());
    if(result == '1'){
      await alert('保存图片失败');
      if(await Utils.showConfirmOptionsDialog(tips: '请打开APP的相册访问权限', confirmTitle: '设置'))
        await PermissionHandler().openAppSettings();
      return;
    }
    await alert('保存图片成功');
    bool confirm = await Utils.showConfirmOptionsDialog(tips: '去关注${Global.wxName}？', confirmTitle: '打开');
    if(confirm){
      Utils.openWx();
    }
  }
}