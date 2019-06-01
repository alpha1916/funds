import 'package:flutter/material.dart';
import 'package:funds/common/constants.dart';
import 'package:funds/model/contract_data.dart';
import 'package:funds/common/utils.dart';
import 'package:funds/model/coupon_data.dart';
import 'package:funds/routes/contract/coupon_select.dart';
var realWidth;
BuildContext ctx;

class ContractApplyDetailPage extends StatefulWidget {
  final ContractApplyDetailData data;
  ContractApplyDetailPage(this.data);

  @override
  _ContractApplyDetailPageState createState() => _ContractApplyDetailPageState(data);
}

class _ContractApplyDetailPageState extends State<ContractApplyDetailPage> {
  final ContractApplyDetailData data;
  _ContractApplyDetailPageState(this.data);

  @override
  Widget build(BuildContext context) {
    ctx = context;
    realWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text(data.title),
        actions: [
          Utils.buildMyTradeButton(context),
        ],
      ),
      body:Container(
        color: CustomColors.background2,
        child: Column(
          children: <Widget>[
            Expanded(child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  _buildTitleView(),
                  _buildItemList(),
                  _buildAgreeView(),
                ],
              ),
            ),),
            _buildButton(),
          ],
        ),
      ),
    );

  }

  _buildTitleView() {
    return Center(
      child:Container(
        width: double.infinity,
//        height: realWidth * 0.5,
        padding: EdgeInsets.only(top: adapt(32, realWidth), bottom: adapt(30, realWidth)),
        color: Color(0xFF201F46),
        child: Column(
          children: <Widget>[
            Text(data.total.toString(), style: TextStyle(fontSize: adapt(32, realWidth), color: Color(0xFFFCC94C)),),
            SizedBox(height: adapt(12, realWidth),),
            Text('合约金额 = 申请资金 + 杠杆资金', style: TextStyle(fontSize: adapt(15, realWidth), color: Colors.white),),
            SizedBox(height: adapt(12, realWidth),),
            Container(
              width: adapt(150, realWidth),
              height: adapt(25, realWidth),
              decoration: BoxDecoration(
                color: CustomColors.red,
                borderRadius: BorderRadius.all(Radius.circular(adapt(10, realWidth))),
              ),
              child: Center(
                child: Text(
                  '${data.profit}%盈利分配',
                  style: TextStyle(
                    fontSize: adapt(15, realWidth),
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      )
    );
  }

  Widget _buildItemView(title, content, contentColor, [titleTips, titleIcon = false, onPressed]) {
    final px12 = adapt(12, realWidth);
    List<Widget> list = [];
    //标题
    list.add(Text(
        title,
        style: TextStyle(
          color: Colors.black87,
          fontSize: adapt(18, realWidth),
          fontWeight: FontWeight.w500,
        )
    ));

    if(titleTips != null) {
      //标题文字提示
      list.add(Container(width: adapt(5, realWidth),));
      list.add(Text(
          '($titleTips)',
          style: TextStyle(
            color: Colors.black54,
            fontSize: adapt(12, realWidth),
          )
      ));
    }else if(titleIcon){
      //标题图标
      list.add(Container(width: adapt(5, realWidth),));
      list.add(Icon(Icons.help));
    }
    list.add(Expanded(child: Container()));
    list.add(Text(
        content,
        style: TextStyle(
          color: contentColor,
          fontSize: adapt(16, realWidth),
          fontWeight: FontWeight.w500,
        )
    ));

    Widget view = Container(
      color: Colors.white,
      padding: EdgeInsets.only(left: px12, right: px12, top: px12, bottom: px12),
      child: Row(
        children: list,
      ),
    );

    if(onPressed == null){
      return view;
    }

    return GestureDetector(
      child: view,
      onTap: onPressed,
    );
  }

  int _selectedCouponIdx = -1;
  Widget _buildCouponItemView() {
    final px12 = adapt(12, realWidth);
    String content1;
    String content2;
    if(_selectedCouponIdx != -1){
      CouponData couponData = data.coupons[_selectedCouponIdx];
      content1 = '${couponData.cost} 元';
      content2 = '优惠券';
    }else{
      content1 = data.coupons.length.toString();
      content2 = '张可用';
    }
    List<Widget> list = [];
    //标题
    list.add(Text(
        '抵用券',
        style: TextStyle(
          color: Colors.black87,
          fontSize: adapt(18, realWidth),
          fontWeight: FontWeight.w500,
        )
    ));

    list.add(Expanded(child: Container()));
    list.add(Text(
        content1,
        style: TextStyle(
          color: CustomColors.red,
          fontSize: adapt(16, realWidth),
          fontWeight: FontWeight.w500,
        )
    ));
    list.add(Text(
        content2,
        style: TextStyle(
          color: Colors.black87,
          fontSize: adapt(16, realWidth),
          fontWeight: FontWeight.w500,
        )
    ));

    list.add(
      Image.asset(CustomIcons.rightArrow, width: adapt(16, realWidth), height: adapt(14, realWidth)),
    );

    return GestureDetector(
      child: Container(
        color: Colors.white,
        padding: EdgeInsets.only(left: px12, right: px12, top: px12, bottom: px12),
        child: Row(
          children: list,
        ),
      ),
      onTap: () async{
        final int idx = await Navigator.of(ctx).push(
          new MaterialPageRoute(
              builder: (_) {
                return CouponSelectPage(data.coupons, _selectedCouponIdx);
              }),
        );

        print('select $idx');
        if(idx != null){
          setState(() {
            _selectedCouponIdx = _selectedCouponIdx == idx ? -1 : idx;
          });
        }
      },
    );
  }

  Widget _buildItemSplit() {
    return Container(
        height: 1,
        color: Colors.black12,
        margin: EdgeInsets.only(left: adapt(12, realWidth)),
    );
  }

  _buildItemList() {
    final Color blackColor = Colors.black87;
    List<Widget> list = [];
    list.add(_buildItemView('杠杆本金', '${data.capital} 元', CustomColors.red));
    list.add(_buildItemSplit());

    final titleTips = data.cost > 0 ? '预存2日费用' : '免管理费';
    list.add(_buildItemView('管理费', '${data.cost} 元/交易日', CustomColors.red, titleTips), );
    list.add(_buildItemSplit());

    list.add(_buildItemView('警戒线', '${data.cordon} 元', blackColor, null, true, (){
      alert2(ctx, '警戒线', '触及警戒线会被限制买入，只能卖出。请密切关注并及时追加保证金至警戒线', '知道了');
    }));
    list.add(_buildItemSplit());

    list.add(_buildItemView('止损线', '${data.cut} 元', blackColor, null, true, (){
      alert2(ctx, '止损线', '当触及止损线，即会被强制平仓', '知道了');
    }));
    list.add(_buildItemSplit());

    list.add(_buildItemView('单票持仓', data.holdTips, blackColor), );
    list.add(_buildItemSplit());

    list.add(_buildItemView('开始交易', data.date, blackColor), );
    list.add(_buildItemSplit());

    list.add(_buildItemView('持仓时间', data.period, blackColor), );
    list.add(_buildItemSplit());

    if(data.coupons.length > 0) {
      list.add(_buildCouponItemView());
      list.add(_buildItemSplit());
    }

    return Column(
      children: list,
    );
  }

  _buildAgreeView() {
    return Container(
      margin: EdgeInsets.only(top: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            '申请即表示已阅读并同意',
            style: TextStyle(
              color: Colors.black87,
              fontSize: 16,
            ),
          ),
          FlatButton(
            child: Text(
              '《操盘协议》',
              style: TextStyle(
                color: Colors.black87,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            onPressed: (){
              alert(ctx, '协议界面未做');
            },
          )
        ],
      ),
    );
  }

  _buildButton() {
    return Container(
      width: realWidth,
      height: adapt(50, realWidth),
      child: RaisedButton(
        child: Text(
          '立即申请',
          style: TextStyle(color: Colors.white, fontSize: adapt(18, realWidth)),
        ),
        onPressed: _onPressedNext,
        color: Colors.black,
      ),
    );
  }

  _onPressedNext() {
  }
}
