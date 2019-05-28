import 'package:flutter/material.dart';
import '../common/constants.dart';

class MyView extends StatefulWidget {
  @override
  _MyViewState createState() => _MyViewState();
}

class _MyViewState extends State<MyView> {
  String mail = CustomIcons.mail0;
  var _data;

  String _name;
  String _stock;
  String _money;
  String _total;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
//    _data = {
//      'name': '139****7109',
//      'stock': '1413.73',
//      'money': '2.35',
//      'total': '1416.08',
//    };

    _name = '139****7109';
    _stock = '1413.73';
    _money = '2.35';
    _total = '1416.08';
  }

  Widget build(BuildContext context) {
    final Widget iconService = Image.asset(CustomIcons.service, width: CustomSize.icon, height: CustomSize.icon);
    final Widget iconMail = Image.asset(mail, width: CustomSize.icon, height: CustomSize.icon);
    return Scaffold(
      appBar: AppBar(
        title:Text('我的'),
        leading: IconButton(
            icon: iconService,
            onPressed: (){
              print('press service');
            }
        ),
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
            _buildTopView(),
            _buildBottomView(),
          ],
        ),
      ),
    );
  }

  //---------------------------------上部分-------------------------------------/
  _buildArrayIcon() {
    return Image.asset(CustomIcons.rightArrow, width: 7.5, height: 14,);
  }

  _buildTableRow(title, value, hasDivider, onPressed) {
    TextStyle ts = TextStyle(color: Colors.white, fontSize: 15);
    List<Widget> children = [
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(title, style: ts),
          Text(value, style: ts),
        ],
      ),
      Expanded(child: Container()),
      _buildArrayIcon(),
      SizedBox(width: 16),
    ];
    if(hasDivider)
      children.add(Container(height: 30, width: 1,color: Colors.white30,));

    return GestureDetector(
      child: Container(
        padding: EdgeInsets.only(left: 20),
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
          style: TextStyle(color: titleColor, fontSize: 15),
        ),
        onPressed: onPressed,
        color: color,
        shape: StadiumBorder(),
      ),
      width: 70,
      height: 30,
    );
  }
  
  _buildTopView() {
    return Container(
      color: Color(0xFF201F46),
      child: Column(
        children: <Widget>[
          //用户名，个人设置
          Row(
            children: <Widget>[
              SizedBox(width: 16,),
              Text(
                '用户：$_name',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18
                ),
              ),
              Expanded(child:Container()),
              FlatButton(
                child: const Text(
                  '个人设置',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  )
                ),
                onPressed: () {
                  print('press setting');
                },
              ),
              Image.asset(CustomIcons.rightArrow, width: 7.5, height: 14,),
              SizedBox(width: 16),
            ],
          ),

          // 证券、余额
          Table(
            defaultVerticalAlignment: TableCellVerticalAlignment.top,
            children: <TableRow>[
              TableRow(
                children: <Widget>[
                  _buildTableRow('证券净值', _stock, true, _onPressContract),
                  _buildTableRow('现金金额', _money, false, _onPressCashFlow),
                ],
              ),
            ],
          ),
          SizedBox(height: 10),
          Container(
            margin: EdgeInsets.only(left: 20),
            height: 1,
            color: Colors.white30,
          ),

          SizedBox(height: 25),
          //资产总计
          Row(
            children: <Widget>[
              SizedBox(width: 20,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('资产总计', style: TextStyle(color: Colors.white, fontSize: 15),),
                  SizedBox(height: 3),
                  Text(_total, style: TextStyle(color: Color(0xFFFDC336), fontSize: 20),),
                ],
              ),
              Expanded(child: Container()),
              _buildButton('充值', Colors.white, CustomColors.red, _onPressCharge),
              SizedBox(width: 15),
              _buildButton('提现', Colors.black87, Colors.white, _onPressWithdraw),
              SizedBox(width: 20),
            ],
          ),
          SizedBox(height: 25),
        ],
      ),
    );
  }

  //---------------------------------上部分 end-------------------------------------/

  //---------------------------------下部分-------------------------------------/
  _buildBottomItem(iconPath, title, hot, tips, onPressed){
    final titleStyle = TextStyle(color: Colors.black87, fontSize: 16);
    final tipsStyle = TextStyle(color: Colors.black54, fontSize: 16);

    return GestureDetector(
      child: Container(
          color: Colors.white,
          padding: EdgeInsets.only(left: 15, right: 16, top: 10, bottom: 10),
          child: Row(
            children: <Widget>[
              Image.asset(iconPath, width: 20,),
              SizedBox(width: 15,),
              Text(title, style: titleStyle,),
              Expanded(child: Container()),
              Text(tips, style: tipsStyle,),
              SizedBox(width: 10,),
              _buildArrayIcon(),
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
          margin: EdgeInsets.only(top: 10),
          child: Column(
            children: <Widget>[
              _buildBottomItem(CustomIcons.myShare, '分享赚钱', true, '', _onPressShare),
              SizedBox(height: 10),

              _buildBottomItem(CustomIcons.myAsset, '资金明细', true, '现金、积分、金币', _onPressFund),
              _buildBottomItem(CustomIcons.myCoupon, '优惠卡券', true, '兑换优惠券', _onPressCard),
              SizedBox(height: 10),
              _buildBottomItem(CustomIcons.myService, '帮助与客服', true, '', _onPressService),
              Container(
                margin: EdgeInsets.only(left: 20),
                height: 1,
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
  }

  _onPressFund() {
    print('press fund');
  }
}

//1、“首页”对比涨8去掉新手学堂、任务中心、分享赚钱。
//2、“我的”去掉金币商城、任务中心、我的订单。积分卡券换成优惠卡券。