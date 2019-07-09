import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:funds/common/utils.dart';
import 'package:funds/common/constants.dart';
import 'package:funds/network/user_request.dart';

class SuggestPage extends StatefulWidget {
  @override
  _SuggestPageState createState() => _SuggestPageState();
}

class _SuggestPageState extends State<SuggestPage> {
  String _strType;

  TextEditingController contentController = TextEditingController();
  TextEditingController contactController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    if(Global.debug){
      contentController.text = '四六级咖喱十几个萨克管就爱看龙盛估计';
      _strType = '交易问题';
//      contactController.text = '';
    }
    TextStyle titleStyle = TextStyle(fontSize: a.px17, color: Colors.black, fontWeight: FontWeight.w400);
    return Scaffold(
      appBar: AppBar(
        title:Text('投诉建议'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              color: Colors.white,
              child: Column(
                children: <Widget>[
                  InkWell(
                    child: Container(
                      padding: EdgeInsets.all(a.px16),
                      child: Row(
                        children: <Widget>[
                          Text('选择类型', style: titleStyle),
                          Utils.expanded(),
                          Text(_strType ?? '请选择', style: titleStyle),
                          Utils.buildForwardIcon(),
                        ],
                      ),
                    ),
                    onTap: _onPressedSelectType,
                  ),
                  Divider(height: 0, indent: a.px16),
                  Padding(
                    padding: EdgeInsets.all(a.px16),
                    child: Row(
                      children: <Widget>[
                        Text('联系方式（选填）', style: titleStyle),
                        Expanded(
                          child: TextField(
                            controller: contactController,
                            cursorColor: Colors.black12,
                            textAlign: TextAlign.right,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: '您的联系方式',
                              labelStyle: TextStyle(fontSize: a.px16),
                            ),
                            style: TextStyle(fontSize: a.px16),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(height: 0),
                  Container(
                    padding: EdgeInsets.all(a.px16),
                    child: Column(
                      children: <Widget>[
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text('留言内容', style: titleStyle),
                        ),
                        Container(
//                          height: a.px(300),
                          child: TextField(
                            controller: contentController,
                            cursorColor: Colors.black12,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: '请输入您的留言内容，我们会尽快给你反馈',
                              labelStyle: TextStyle(fontSize: a.px16),
                            ),
                            maxLines: 12,
                            style: TextStyle(fontSize: a.px16),
                          ),
                        )
                      ],
                    )
                  ),
                ],
              ),
            ),
            Utils.buildRaisedButton(title: '确认提交', onPressed: _onPressedOK)
          ],
        ),
      ),
    );
  }

  @override
  dispose(){
    super.dispose();
    contactController.dispose();
    contentController.dispose();
  }

  _onPressedOK() async{
    if(_strType == null){
      alert('请选择类型');
      return;
    }

    if(contentController.text.isEmpty){
      alert('请输入内容');
      return;
    }

    if(contentController.text.length < 10 || contentController.text.length > 500){
      alert('问题描述在10到500个字之间');
      return;
    }

    print(contactController.text);
    var result = await UserRequest.suggest(_strType, contentController.text, contactController.text);
    if(result.success){
      await alert2('提示', '感谢您的反馈，我们会尽快给您答复', '知道了');
      Utils.navigatePop();
    }
  }

  final List<String> _strTypes = ['账号充值及提款问题', '交易问题', '我要投诉', '意见反馈', '其他问题'];
  _onPressedSelectType() async{
    String result = await Utils.showBottomPopupOptions(titles: _strTypes);
    if (result != null) {
      setState(() {
        _strType = result;
      });
    }
  }
}

