import 'package:flutter/material.dart';
import 'package:funds/common/utils.dart';
import 'package:funds/common/constants.dart';
import 'package:funds/network/http_request.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/gestures.dart';
import 'image_viewer_page.dart';
import 'dart:io';

class RechargePage extends StatefulWidget {
  @override
  _RechargePageState createState() => _RechargePageState();
}

class _RechargePageState extends State<RechargePage> {
  String _comment;
  String _imagePath;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('充值'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  _buildAmountInputView(),
                  _buildCommentView(),
                  _imagePath != null ? _buildImageView() : _buildProofView(),
                  _buildTipsView(),
                ],
              ),
            ),
          ),
          Utils.buildFullWidthButton('确认', _onPressOK),
        ],
      )
    );
  }

  TextEditingController inputController = TextEditingController();
  _buildAmountInputView() {
    double fontSize = a.px18;
    return Container(
      color: Colors.white,
      child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.symmetric(vertical: a.px2, horizontal: a.px16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  '转账金额',
                  style: TextStyle(fontSize: fontSize),
                ),
                Container(
                  width: a.px(200),
                  child: TextField(
                    textAlign: TextAlign.right,
                    controller: inputController,
                    cursorColor: Colors.black12,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: '请输入转账金额',
                      labelStyle: TextStyle(fontSize: fontSize),
                    ),
                    autofocus: false,
                  ),
                ),
              ],
            ),
          ),
          Divider(height: a.px1, indent: a.px16)
        ],
      ),
    );
  }

  _buildCommentView() {
    double fontSize = a.px18;
    return Container(
      color: Colors.white,
      child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.symmetric(vertical: a.px12, horizontal: a.px16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  '转账备注',
                  style: TextStyle(fontSize: fontSize),
                ),
                InkWell(
                  child: Container(
                    color: Colors.transparent,
                    child: Row(
                      children: <Widget>[
                        Text(
                          _comment ?? '请选择',
                          style: TextStyle(fontSize: fontSize),
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: a.px16,
                          color: Colors.black54,
                        ),
                      ],
                    ),
                  ),
                  onTap: _onPressSelectComment,
                ),
              ],
            ),
          ),
          Divider(height: a.px1, indent: a.px16)
        ],
      ),
    );
  }

  final List<String> _comments = ['申请合约', '追加本金', '交管理费', '普通充值'];
  _onPressSelectComment() async {
    buildItem(BuildContext context, String comment) {
      return CupertinoActionSheetAction(
        child: Text(comment),
        onPressed: () {
          Navigator.pop(context, comment);
        },
      );
    }

    String result = await showCupertinoModalPopup<String>(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
            actions: _comments
                .map((comment) => buildItem(context, comment))
                .toList(),
            cancelButton: CupertinoActionSheetAction(
              child: const Text('取消'),
              isDefaultAction: true,
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
    );

    if (result != null) {
      setState(() {
        _comment = result;
      });
    }
  }

  _buildProofView() {
    return InkWell(
      child: Container(
        color: Colors.white,
        padding: EdgeInsets.symmetric(vertical: a.px30),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(Icons.add),
              Text(
                '添加转账凭证',
                style: TextStyle(fontSize: a.px20),
              )
            ],
          ),
        ),
      ),
      onTap: (){
        _showAddImageOptions();
      },
    );
  }

  _buildImageView(){
    return InkWell(
      child: Container(
        padding: EdgeInsets.all(a.px20),
        alignment: Alignment.centerLeft,
        color: Colors.white,
        child: Stack(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(a.px10),
              child: Image.asset(_imagePath, width: a.px(50),),
            ),
            Positioned(
              right: 0,
              top: 0,
              child: InkWell(
                child: CircleAvatar(
                  radius: a.px10,
                  child: Icon(Icons.clear, color: Colors.white, size: a.px18,),
                  backgroundColor: CustomColors.red,
                ),
                onTap: () => _updateImage(null),
              ),
            )
          ],
        )
      ),
      onTap: () async{
        var result = await Utils.navigateTo(ImageViewerPage(_imagePath));
        if(result != null){
          _updateImage(null);
        }
      },
    );
  }

  _updateImage(path) {
    setState(() {
      _imagePath = path;
    });
  }

  _buildTipsView() {
//    温馨提示：
//    1、 已完成线下转账的用户，请通过本页面提交线下转账凭证；
//    2、 请明确填写的充值金额与实际转账金额一致，转账凭证中包含
//    付款人、收款人、金额三要素；图片示例
//    3、如果遇到任何问题，请联系客服：400-603-0008
    TextStyle style = TextStyle(fontSize: a.px13, color: Colors.black38);
    return Padding(
      padding: EdgeInsets.all(a.px16),
      child: RichText(
        text: TextSpan(
          children: <TextSpan>[
            TextSpan(
             text: '温馨提示：\n\n1、 已完成线下转账的用户，请通过本页面提交线下转账凭证；\n\n2、 请明确填写的充值金额与实际转账金额一致，转账凭证中包含付款人、收款人、金额三要素；',
             style: style
           ),
            TextSpan(
              text: '图片示例',
              style: TextStyle(decoration: TextDecoration.underline, fontSize: a.px13, color: Colors.black),
              recognizer: TapGestureRecognizer()..onTap = () {
                print('hhh');
                Utils.navigateTo(ImageViewerPage(CustomIcons.rechargeSample));
              }
            ),
            TextSpan(
                text: '\n\n3、如果遇到任何问题，请联系客服：',
                style: style
            ),
            TextSpan(
                text: '400-603-0008',
                style: TextStyle(decoration: TextDecoration.underline, fontSize: a.px13, color: Colors.black),
                recognizer: TapGestureRecognizer()..onTap = () {
                  Utils.dial('400-603-0008');
                }
            ),
          ],
        )
      ),
    );
  }

  _onPressOK() async {
    if(inputController.text.length == 0){
      alert('请输入充值金额');
      return;
    }
    double num;
    try{
      num = double.parse(inputController.text);
    }catch(e){
      alert('请输入正确的充值金额');
      return;
    }

    if(_comment == null){
      alert('请选择备注');
      return;
    }

    if(_imagePath == null){
      alert('请先添加转账凭证');
      return;
    }

    ResultData result = await RechargeRequest.recharge(num, _comment);
    if (result.success) {
//      alert('充值请求已提交，请等待工作人员核实');
      alert('提交成功，我们会尽快完成审核\n(测试无审核阶段，已充值成功)');
      Utils.navigatePop(true);
//      inputController.clear();
//      setState(() {
//        _comment = null;
//      });
    }
  }

  _takePhoto() async {
    await Utils.navigatePop();
    File image = await ImagePicker.pickImage(source: ImageSource.camera);
    print(image.path);

    _updateImage(image.path);
  }

  /*相册*/
  _openGallery() async {
    await Utils.navigatePop();
    File image = await ImagePicker.pickImage(source: ImageSource.gallery);
    print(image.path);
    _updateImage(image.path);
  }

  _showAddImageOptions(){
    TextStyle style = TextStyle(fontSize: a.px16, fontWeight: FontWeight.w500);
    buildButton(title, image, onPressed){
      return Column(
        children: <Widget>[
          IconButton(
            padding: EdgeInsets.all(0),
            color: CustomColors.red,
            icon: Image.asset(image),
            iconSize: a.px(100),
            onPressed: onPressed,
          ),
          SizedBox(height: a.px10),
          Text(title, style: style,),
        ],
      );
    }
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context){
        return Container(
          height: a.px(240),
          child: Column(
            children: <Widget>[
              SizedBox(height: a.px10),
              Text('选取照片', style: style,),
              SizedBox(height: a.px20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  buildButton('相册选取',CustomIcons.photo, _openGallery),
                  buildButton('相机拍照',CustomIcons.camera, _takePhoto),
                ],
              ),
            ],
          ),
        );
      }
    );
  }
}
