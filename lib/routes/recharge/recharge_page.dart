import 'package:flutter/material.dart';
import 'package:funds/common/utils.dart';
import 'package:funds/common/constants.dart';
import 'package:funds/network/http_request.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';

class RechargePage extends StatefulWidget {
  @override
  _RechargePageState createState() => _RechargePageState();
}

class _RechargePageState extends State<RechargePage> {
  String _comment;
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
                  _buildProofView(),
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
          Container(
            color: Colors.black26,
            margin: EdgeInsets.only(left: a.px16),
            height: 1,
          )
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
          Container(
            color: Colors.black26,
            margin: EdgeInsets.only(left: a.px16),
            height: 1,
          )
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
//        alert('功能未实现');
        print('add');
//        _openGallery();
        _showAddImageOptions();
      },
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

    ResultData result = await RechargeRequest.recharge(num, _comment);
    if (result.success) {
//      alert('充值请求已提交，请等待工作人员核实');
      alert('提交成功，我们会尽快完成审核\n(测试无审核阶段，已充值成功)');
      inputController.clear();
      setState(() {
        _comment = null;
      });
    }
  }

  _takePhoto() async {
    Utils.navigatePop();
//    var image = await ImagePicker.pickImage(source: ImageSource.camera);
//    print(image);
//
//    setState(() {
//      _imgPath = image;
//    });
  }

  /*相册*/
  _openGallery() async {
    Utils.navigatePop();
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
//    print(image);
//    setState(() {
//      _imgPath = image;
//    });
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
