import 'package:flutter/material.dart';
import 'package:funds/common/constants.dart';
import 'package:funds/common/utils.dart';
import 'package:funds/model/coupon_data.dart';
import 'package:funds/network/user_request.dart';

class CouponsPage extends StatefulWidget {
  @override
  _CouponsPageState createState() => _CouponsPageState();
}

class _CouponsPageState extends State<CouponsPage> {
  List<CouponData> _myCoupons;
  List<CouponData> _shopCoupons;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:Text('优惠卡券'),
      ),
      body: Container(
        color: CustomColors.background1,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              _buildMyListView(),
              SizedBox(height: 16,),
              _buildShopListView(),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _refresh();
  }

  _refresh() async {
    if (_shopCoupons == null){
      ResultData result = await UserRequest.getShopCouponsData();
      if (!result.success)
        return;
      _shopCoupons = result.data;
    }

    ResultData result = await UserRequest.getMyCouponsData();
    if (!result.success)
      return;
    _myCoupons= result.data;

    setState(() {

    });
  }


  _buildMyListView() {
    Widget contentView;
    if(_myCoupons == null || _myCoupons.length == 0){
      contentView = Container(
        padding: EdgeInsets.only(top: a.px30, bottom: a.px10),
        child: Column(
          children: <Widget>[
            Text('当前没有卡券', style: TextStyle(fontSize: a.px15, color: Colors.black38),),
            Utils.buildUnderlineTextButton('点击前往操盘获得积分进行兑换', a.px18, () => Utils.navigatePopAll(AppTabIndex.funds)),
          ],
        ),
      );
    }else{
      contentView = _buildCouponsView(_myCoupons);
    }
    return Container(
      color: Colors.white,
      child: Column(
        children: <Widget>[
          Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.symmetric(horizontal: a.px16, vertical: a.px8),
            child: Text('我的卡券', style: TextStyle(fontSize: a.px17, fontWeight: FontWeight.w400)),
          ),
          Utils.buildSplitLine(margin: EdgeInsets.only(left: a.px16)),
          contentView,
          SizedBox(height: a.px16),
        ],
      ),
    );
  }

  _buildShopListView() {
    return Container(
      color: Colors.white,
      child: Column(
        children: <Widget>[
          Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.symmetric(horizontal: a.px16, vertical: a.px8),
            child: Row(
              children: <Widget>[
                Text('卡券商城', style: TextStyle(fontSize: a.px17, fontWeight: FontWeight.w400)),
                Utils.expanded(),
                Text('我的积分:', style: TextStyle(fontSize: a.px16, color: Colors.black54)),
                Text(AccountData.getInstance().integral.toString(), style: TextStyle(fontSize: a.px16, color: CustomColors.red)),
              ],
            ),
          ),
          Utils.buildSplitLine(margin: EdgeInsets.only(left: a.px16)),
          _buildCouponsView(_shopCoupons, true),
          SizedBox(height: a.px16),
        ],
      ),
    );
  }

  _getBGPath(cost) {
    if(cost < 200){
      return CustomIcons.couponBG1;
    }else if(cost < 1000){
      return CustomIcons.couponBG2;
    }
    return CustomIcons.couponBG3;
  }

  _buildCouponsView(List<CouponData> coupons, [saleable = false]) {
    if(coupons == null || coupons.length == 0){
      return Container();
    }

    final double itemHeight = a.px(70);
    final BorderSide borderSide = BorderSide(width: a.px(0.5), style: BorderStyle.solid, color: Colors.black26);
    Border border = Border(top: borderSide, bottom: borderSide, right: borderSide);
    return Container(
      child: Column(
        children: coupons.map((data) {
          String tips = data.integral != null ? '${data.integral} 积分' : '有效期至：${data.expireDate}';
          List<Widget> list = [
            Container(
              width: itemHeight * 282 / 134,
              height: itemHeight,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(_getBGPath(data.cost)),
                  fit: BoxFit.fitHeight,
                ),
              ),
              child: Row(
                children: <Widget>[
                  SizedBox(width: a.px12,),
                  Text('￥\n', style: TextStyle(color: Colors.white, fontSize: a.px25)),
                  Expanded(child: Container(),),
                  Text(data.cost.toString(), style: TextStyle(color: Colors.white, fontSize: a.px36)),
                  SizedBox(width: a.px12,),
                ],
              ),
            ),
            Container(
              width: a.px(232),
              padding: EdgeInsets.only(left: a.px10, right: a.px20),
              decoration: BoxDecoration(
                border: border,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('管理费抵用券', style: TextStyle(color: Colors.black87, fontSize: a.px15, fontWeight: FontWeight.w500)),
                      SizedBox(height: a.px3,),
                      Text(tips, style: TextStyle(color: Colors.black54, fontSize: a.px14)),
                    ],
                  ),
                  saleable ? GestureDetector(
                    child: CircleAvatar(
                      radius: a.px14,
                      backgroundColor: Colors.black,
                      child: Text('兑', style: TextStyle(fontSize: a.px18, color: Colors.white),),
                    ),
                    onTap: (){
                      _onPressedExchange(data);
                    },
                  ) : Container(),
                ],
              ),
            ),
          ];

          return Container(
            height: itemHeight,
            margin: EdgeInsets.fromLTRB(a.px16, a.px16, a.px16, 0),
            color: Colors.white,
            child: Row(
              children: list,
            ),
          );
        }).toList(),
      )
    );
  }

  _onPressedExchange(CouponData data) async{
    if(AccountData.getInstance().integral < data.integral){
      alert('积分不足');
      return;
    }
    bool confirm = await Utils.showConfirmOptionsDialog(tips: '确认消耗${data.integral}积分进行兑换');
    if(confirm){
      final result = await UserRequest.exchangeCoupon(data.id);
      if(result.success){
        await UserRequest.getUserInfo();
        _refresh();
      }
    }
  }
}