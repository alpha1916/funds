import 'package:flutter/material.dart';
import 'package:funds/common/constants.dart';
import 'package:funds/common/utils.dart';
import 'package:funds/model/account_data.dart';
import 'package:funds/routes/recharge/recharge_page.dart';
import 'package:funds/network/user_request.dart';
import 'package:funds/routes/my/settings_page.dart';
import 'package:funds/routes/my/cash_flow_page.dart';
import 'package:funds/routes/my/funds_detail_page.dart';

import 'package:funds/routes/my/task_page.dart';
import 'package:funds/routes/my/coupons_page.dart';
import 'package:funds/routes/my/about/about_page.dart';
import 'package:funds/routes/my/help_page.dart';

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
          body: Column(
            children: <Widget>[
              AccountData.getInstance().isLogin() ? _buildTopView() : _buildLoginView(),
              _buildBottomView(),
            ],
          ),
        );
      }
    );
  }

  //---------------------------------上部分-------------------------------------/

  _buildRow(title, value, hasDivider, onPressed) {
    TextStyle ts = TextStyle(color: Colors.white, fontSize: a.px16);
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

    return InkWell(
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
          style: TextStyle(color: titleColor, fontSize: a.px16),
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
      padding: EdgeInsets.symmetric(vertical: a.px(60)),
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
      color: CustomColors.backgroundBlue,
      child: Column(
        children: <Widget>[
          SizedBox(height: a.px12),
          //用户名，个人设置
          InkWell(
            child: Row(
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
                Text(
                  '个人设置',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: a.px17,
                  )
                ),
                Utils.buildForwardIcon(color: Colors.white),
                SizedBox(width: a.px16),
              ],
            ),

            onTap: () {
              print('press setting');
              Utils.navigateTo(SettingsPage());
            },
          ),

          // 证券、余额
          Row(
            children: <Widget>[
              Expanded(
                child: _buildRow('证券净值', _data.stock.toStringAsFixed(2), true, _onPressContract),
              ),
              Expanded(
                child: _buildRow('现金金额', _data.cash.toStringAsFixed(2), false, _onPressCashFlow),
              ),
            ],
          ),
          SizedBox(height: a.px10),
          Divider(height: 0, color: Colors.white30, indent: a.px20,),
          SizedBox(height: a.px25),
          //资产总计
          Row(
            children: <Widget>[
              SizedBox(width: a.px20,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('资产总计', style: TextStyle(color: Colors.white, fontSize: a.px16),),
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
    final titleStyle = TextStyle(color: Colors.black87, fontSize: a.px17);
    final tipsStyle = TextStyle(color: Colors.black54, fontSize: a.px17);

    return InkWell(
      child: Container(
          color: Colors.white,
          padding: EdgeInsets.only(left: a.px15, right: a.px16, top: a.px10, bottom: a.px10),
          child: Row(
            children: <Widget>[
              Image.asset(iconPath, width: a.px16,),
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
//                    Divider(height: a.px1, indent: a.px16),
//                    _buildBottomItem(CustomIcons.myShare, '分享赚钱', true, '', _onPressShare),
                  ],
                ),
              ),
              SizedBox(height: a.px10),
              Container(
                color: Colors.white,
                child: Column(
                  children: <Widget>[
                    _buildBottomItem(CustomIcons.myAsset, '资金明细', false, '现金、积分', _onPressFund),
                    Divider(height: a.px1, indent: a.px16),
                    _buildBottomItem(CustomIcons.myCoupon, '优惠卡券', false, '兑换优惠券', _onPressCoupons),
                  ],
                ),
              ),
              SizedBox(height: a.px10),
              Container(
                color: Colors.white,
                child: Column(
                  children: <Widget>[
                    _buildBottomItem(CustomIcons.myService, '帮助与客服', false, '', _onPressHelp),
//                    Divider(height: a.px1, indent: a.px16),
//                    _buildBottomItem(CustomIcons.myAbout, '关于${Global.appName}', false, '', _onPressAbout),
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
    if(Utils.needLogin())
      return;

    Utils.navigateTo(CashFlowPage());
  }

  _onPressCoupons () {
    if(Utils.needLogin())
      return;
    Utils.navigateTo(CouponsPage());
  }

  _onPressHelp () {
    Utils.navigateTo(HelpPage());
  }

  _onPressAbout () {
    Utils.navigateTo(AboutPage());
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
    Utils.appMainTabSwitch(AppTabIndex.trade);
  }

  _onPressFund() {
    if(Utils.needLogin())
      return;
    Utils.navigateTo(FundsDetailPage());
  }
}