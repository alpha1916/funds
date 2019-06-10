import 'package:flutter/material.dart';
import 'package:funds/common/constants.dart';
import 'package:funds/common/utils.dart';
import 'package:funds/model/account_data.dart';
import 'package:funds/network/http_request.dart';

class MyView extends StatefulWidget {
  @override
  _MyViewState createState() => _MyViewState();
}

class _MyViewState extends State<MyView> {
  String mail = CustomIcons.mail0;
//  AccountData _data;

  String _name = '';
  String _stock = '0.00';
  String _cash = '0.00';
  String _total = '0.00';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _updateInfo();
    _refresh();
  }

  _refresh() async{
    if(!AccountData.getInstance().isLogin())
      return;

    await Future.delayed(Duration(milliseconds: 10));
    ResultData result = await UserRequest.getUserInfo();
    if(!mounted)
      return;

    if(result.success){
      _updateInfo();
    }
    setState(() {
    });
  }

  _updateInfo() {
    AccountData data = AccountData.getInstance();
    _name = data.phone;
    _stock = data.stock.toStringAsFixed(2);
    _cash = data.cash.toStringAsFixed(2);
    _total = (data.cash + data.stock).toStringAsFixed(2);
  }

  Widget build(BuildContext context) {
    final Widget iconMail = Image.asset(mail, width: a.px22, height: a.px22);
    return Scaffold(
      appBar: AppBar(
        title:Text('我的'),
        leading: Utils.buildServiceIconButton(context),
        actions: [
          IconButton(
              icon: iconMail,
              onPressed: (){
                print('press mail');
              }
          ),
        ],
      ),
      body: Container(
        color: CustomColors.background1,
        child: Column(
          children: <Widget>[
            AccountData.getInstance().isLogin() ? _buildTopView() : _buildLoginView(),
            _buildBottomView(),
          ],
        ),
      ),
    );
  }

  //---------------------------------上部分-------------------------------------/
  _buildArrayIcon(color) {
    return Icon(Icons.arrow_forward_ios, color: color, size: a.px16);
  }

  _buildTableRow(title, value, hasDivider, onPressed) {
    TextStyle ts = TextStyle(color: Colors.white, fontSize: a.px15);
    List<Widget> children = [
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(title, style: ts),
          Text(value, style: ts),
        ],
      ),
      Expanded(child: Container()),
      _buildArrayIcon(Colors.white),
      SizedBox(width: a.px16),
    ];
    if(hasDivider)
      children.add(Container(height: a.px30, width: 1,color: Colors.white30,));

    return GestureDetector(
      child: Container(
        padding: EdgeInsets.only(left: a.px20),
        child: Row(
          children: children,
        ),
      ),
      onTap: onPressed,
    );
  }

  Widget _buildButton(title, titleColor, color, onPressed) {
    return Container(
      child:RaisedButton(
        child: Text(
          title,
          style: TextStyle(color: titleColor, fontSize: a.px15),
        ),
        onPressed: onPressed,
        color: color,
        shape: StadiumBorder(),
      ),
      width: a.px(70),
      height: a.px30,
    );
  }

  _buildLoginView() {
    Widget buildButton(title, [isRegister = false]) {
      return Container(
        child:RaisedButton(
          child: Text(
            title,
            style: TextStyle(color: CustomColors.red, fontSize: a.px18),
          ),
          onPressed: () {
            Utils.navigateToLoginPage(isRegister);
          },
          color: Colors.white,
          shape: StadiumBorder(),
        ),
        width: a.px(120),
        height: a.px(40),
      );
    }

    return Container(
      height: a.px(200),
      color: Color(0xFF201F46),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          buildButton('登录'),
          buildButton('注册', true),
        ],
      ),
    );
  }
  
  _buildTopView() {
    return Container(
      height: a.px(200),
      color: Color(0xFF201F46),
      child: Column(
        children: <Widget>[
          //用户名，个人设置
          Row(
            children: <Widget>[
              SizedBox(width: a.px20,),
              Text(
                '用户：$_name',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: a.px18
                ),
              ),
              Expanded(child:Container()),
              FlatButton(
                child: Text(
                  '个人设置',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: a.px16,
                  )
                ),
                onPressed: () {
                  print('press setting');
                },
              ),
              Icon(Icons.arrow_forward_ios, color: Colors.white, size: a.px16),

              SizedBox(width: a.px16),
            ],
          ),

          // 证券、余额
          Table(
            defaultVerticalAlignment: TableCellVerticalAlignment.top,
            children: <TableRow>[
              TableRow(
                children: <Widget>[
                  _buildTableRow('证券净值', _stock, true, _onPressContract),
                  _buildTableRow('现金金额', _cash, false, _onPressCashFlow),
                ],
              ),
            ],
          ),
          SizedBox(height: a.px10),
          Container(
            margin: EdgeInsets.only(left: a.px20),
            height: a.px1,
            color: Colors.white30,
          ),

          SizedBox(height: a.px25),
          //资产总计
          Row(
            children: <Widget>[
              SizedBox(width: a.px20,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('资产总计', style: TextStyle(color: Colors.white, fontSize: a.px15),),
                  SizedBox(height: a.px3),
                  Text(_total, style: TextStyle(color: Color(0xFFFDC336), fontSize: a.px20),),
                ],
              ),
              Expanded(child: Container()),
              _buildButton('充值', Colors.white, CustomColors.red, _onPressCharge),
              SizedBox(width: a.px15),
              _buildButton('提现', Colors.black87, Colors.white, _onPressWithdraw),
              SizedBox(width: a.px20),
            ],
          ),
          SizedBox(height: a.px25),
        ],
      ),
    );
  }

  //---------------------------------上部分 end-------------------------------------/

  //---------------------------------下部分-------------------------------------/
  _buildBottomItem(iconPath, title, hot, tips, onPressed){
    final titleStyle = TextStyle(color: Colors.black87, fontSize: a.px16);
    final tipsStyle = TextStyle(color: Colors.black54, fontSize: a.px16);

    return GestureDetector(
      child: Container(
          color: Colors.white,
          padding: EdgeInsets.only(left: a.px15, right: a.px16, top: a.px10, bottom: a.px10),
          child: Row(
            children: <Widget>[
              Image.asset(iconPath, width: a.px20,),
              SizedBox(width: a.px15,),
              Text(title, style: titleStyle,),
              Expanded(child: Container()),
              Text(tips, style: tipsStyle,),
              SizedBox(width: a.px10,),
              _buildArrayIcon(Colors.black26),
            ],
          )
      ),
      onTap: onPressed,
    );
  }

  _buildBottomView() {
    return Expanded(
      child: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(top: a.px10),
          child: Column(
            children: <Widget>[
              _buildBottomItem(CustomIcons.myShare, '分享赚钱', true, '', _onPressShare),
              SizedBox(height: a.px10),

              _buildBottomItem(CustomIcons.myAsset, '资金明细', true, '现金、积分、金币', _onPressFund),
              _buildBottomItem(CustomIcons.myCoupon, '优惠卡券', true, '兑换优惠券', _onPressCard),
              SizedBox(height: a.px10),
              _buildBottomItem(CustomIcons.myService, '帮助与客服', true, '', _onPressService),
              Container(
                margin: EdgeInsets.only(left: a.px20),
                height: a.px1,
                color: Colors.black12,
              ),
              _buildBottomItem(CustomIcons.myAbout, '关于xx', true, '', _onPressAbout),
            ],
          ),
        ),
      ),
    );
  }
  //---------------------------------下部分 end-------------------------------------/

  _onPressShare () {
    print('press share');
  }

  _onPressCashFlow () {
    print('press cash flow');
  }

  _onPressCard () {
    print('press card');
  }

  _onPressService () {
    print('press service');
  }

  _onPressAbout () {
    print('press about');
  }

  _onPressCharge() {
    print('press charge');
  }

  _onPressWithdraw() {
    print('press withdraw');
  }
  
  _onPressContract() {
    print('press contract');
    Utils.appMainTabSwitch(3);
  }

  _onPressFund() {
    print('press fund');
  }
}

//1、“首页”对比涨8去掉新手学堂、任务中心、分享赚钱。
//2、“我的”去掉金币商城、任务中心、我的订单。积分卡券换成优惠卡券。