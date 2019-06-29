import 'package:flutter/material.dart';
import 'package:funds/common/constants.dart';
import 'package:funds/common/utils.dart';
import 'package:funds/model/account_data.dart';
import 'package:funds/routes/recharge/recharge_page.dart';
import 'package:funds/network/user_request.dart';
import 'package:funds/routes/my/settings_page.dart';
import 'package:funds/routes/my/withdraw_page.dart';
import 'package:funds/routes/my/cash_flow_page.dart';
import 'package:funds/routes/my/funds_detail_page.dart';

import 'package:funds/routes/my/task_page.dart';
import 'package:funds/routes/my/coupons_page.dart';

class MyView extends StatefulWidget {
  @override
  _MyViewState createState() => _MyViewState();
}

class _MyViewState extends State<MyView> {
  AccountData _data;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    UserRequest.getUserInfo();
  }

  Widget build(BuildContext context) {
    return StreamBuilder<AccountData>(
      stream: AccountData.getInstance().dataStream,
      initialData: AccountData.getInstance(),
      builder: (BuildContext context, AsyncSnapshot<AccountData> snapshot){
        _data = snapshot.data;
        return Scaffold(
          appBar: AppBar(
            title:Text('我的'),
            leading: Utils.buildServiceIconButton(context),
            actions: [
              Utils.buildMailIconButton(),
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
    );
  }

  //---------------------------------上部分-------------------------------------/

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
      Utils.buildForwardIcon(color: Colors.white),
      SizedBox(width: a.px16),
    ];
    if(hasDivider)
      children.add(Container(height: a.px30, width: 1,color: Colors.white30,));

    return GestureDetector(
      child: Container(
        color: Colors.transparent,
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
      color: CustomColors.backgroundBlue,
      child: Column(
        children: <Widget>[
          //用户名，个人设置
          Row(
            children: <Widget>[
              SizedBox(width: a.px20,),
              Text(
                '用户：${Utils.convertPhoneNumber(_data.phone)}',
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
                  Utils.navigateTo(SettingsPage());
                },
              ),
              Utils.buildForwardIcon(color: Colors.white),
              SizedBox(width: a.px16),
            ],
          ),

          // 证券、余额
          Table(
            defaultVerticalAlignment: TableCellVerticalAlignment.top,
            children: <TableRow>[
              TableRow(
                children: <Widget>[
                  _buildTableRow('证券净值', _data.stock.toStringAsFixed(2), true, _onPressContract),
                  _buildTableRow('现金金额', _data.cash.toStringAsFixed(2), false, _onPressCashFlow),
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
                  Text(_data.total.toStringAsFixed(2), style: TextStyle(color: CustomColors.textGold, fontSize: a.px20),),
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
  _buildHotView(hot){
    if(!hot)
      return Container();

    return Container(
      width: a.px36,
      height: a.px16,
      decoration: BoxDecoration(
        color: CustomColors.red,
        borderRadius: BorderRadius.all(Radius.circular(a.px10)),
      ),
      child: Center(
        child: Text(
          'HOT',
          style: TextStyle(
            fontSize: a.px12,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
  _buildBottomItem(iconPath, title, hot, tips, onPressed,){
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
              SizedBox(width: a.px15,),
              _buildHotView(hot),
              Expanded(child: Container()),
              Text(tips, style: tipsStyle,),
              SizedBox(width: a.px10,),
              Utils.buildForwardIcon(),
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
              Container(
                color: Colors.white,
                child: Column(
                  children: <Widget>[
                    _buildBottomItem(CustomIcons.task, '任务中心', true, '签到送积分', _onPressTask),
                    Utils.buildSplitLine(margin: EdgeInsets.only(left: a.px16)),
                    _buildBottomItem(CustomIcons.myShare, '分享赚钱', true, '', _onPressShare),
                  ],
                ),
              ),
              SizedBox(height: a.px10),
              Container(
                color: Colors.white,
                child: Column(
                  children: <Widget>[
                    _buildBottomItem(CustomIcons.myAsset, '资金明细', false, '现金、积分', _onPressFund),
                    Utils.buildSplitLine(margin: EdgeInsets.only(left: a.px16)),
                    _buildBottomItem(CustomIcons.myCoupon, '优惠卡券', false, '兑换优惠券', _onPressCoupons),
                  ],
                ),
              ),
              SizedBox(height: a.px10),
              Container(
                color: Colors.white,
                child: Column(
                  children: <Widget>[

                    _buildBottomItem(CustomIcons.myService, '帮助与客服', false, '', _onPressService),
                    Utils.buildSplitLine(margin: EdgeInsets.only(left: a.px16)),
                    _buildBottomItem(CustomIcons.myAbout, '关于xx', false, '', _onPressAbout),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  //---------------------------------下部分 end-------------------------------------/
  _onPressTask() {
    Utils.navigateTo(TaskPage());
  }

  _onPressShare () {
    print('press share');
    alert('功能未实现');
  }

  _onPressCashFlow () async{
    print('press cash flow');
    Utils.navigateTo(CashFlowPage());
  }

  _onPressCoupons () {
    print('press coupons');
    Utils.navigateTo(CouponsPage());
  }

  _onPressService () {
    print('press service');
    alert('功能未实现');
  }

  _onPressAbout () {
    print('press about');
    alert('功能未实现');
  }

  _onPressCharge() async {
    print('press recharge');
    Utils.navigateTo(RechargePage());
//    _refresh();
  }

  _onPressWithdraw() {
    Utils.bankCardWithdraw();
  }
  
  _onPressContract() {
    print('press contract');
    Utils.appMainTabSwitch(3);
  }

  _onPressFund() {
    Utils.navigateTo(FundsDetailPage());
  }
}

//1、“首页”对比涨8去掉新手学堂、任务中心、分享赚钱。
//2、“我的”去掉金币商城、任务中心、我的订单。积分卡券换成优惠卡券。