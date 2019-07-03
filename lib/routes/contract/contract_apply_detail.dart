import 'package:flutter/material.dart';
import 'package:funds/common/constants.dart';
import 'package:funds/model/contract_data.dart';
import 'package:funds/common/utils.dart';
import 'package:funds/common/custom_dialog.dart';
import 'package:funds/network/contract_request.dart';
import 'package:funds/network/user_request.dart';
import 'package:funds/model/coupon_data.dart';
import 'package:funds/routes/contract/coupon_select.dart';
import 'package:funds/routes/recharge/recharge_page.dart';


class ContractApplyDetailPage extends StatefulWidget {
  final ContractApplyDetailData data;
  ContractApplyDetailPage(this.data);

  @override
  _ContractApplyDetailPageState createState() => _ContractApplyDetailPageState();
}

class _ContractApplyDetailPageState extends State<ContractApplyDetailPage> {
  ContractApplyDetailData data;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    data = widget.data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(data.title),
        actions: [
          Utils.buildMyTradeButton(),
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

  _buildProfitTips() {
    //少于100才显示盈利分配
    if(data.profit == 100){
      return Container();
    }
    return Container(
      width: a.px(150),
      height: a.px25,
      decoration: BoxDecoration(
        color: CustomColors.red,
        borderRadius: BorderRadius.all(Radius.circular(a.px10)),
      ),
      child: Center(
        child: Text(
          '${data.profit}%盈利分配',
          style: TextStyle(
            fontSize: a.px15,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  _buildTitleView() {
    return Center(
      child:Container(
        width: double.infinity,
        padding: EdgeInsets.only(top: a.px32, bottom: a.px30),
        color: Color(0xFF201F46),
        child: Column(
          children: <Widget>[
            Text(data.total.toString(), style: TextStyle(fontSize: a.px32, color: Color(0xFFFCC94C)),),
            SizedBox(height: a.px12),
            Text('合约金额 = 申请资金 + 杠杆资金', style: TextStyle(fontSize: a.px15, color: Colors.white),),
            SizedBox(height: a.px12),
            _buildProfitTips(),
          ],
        ),
      )
    );
  }

  Widget _buildItemView(title, content, contentColor, [titleTips, titleIcon = false, onPressed]) {
    final px12 = a.px12;
    List<Widget> list = [];
    //标题
    list.add(Text(
        title,
        style: TextStyle(
          color: Colors.black87,
          fontSize: a.px18,
          fontWeight: FontWeight.w500,
        )
    ));

    if(titleTips != null) {
      //标题文字提示
      list.add(Container(width: a.px5,));
      list.add(Text(
          '($titleTips)',
          style: TextStyle(
            color: Colors.black54,
            fontSize: a.px12,
          )
      ));
    }else if(titleIcon){
      //标题图标
      list.add(Container(width: a.px5,));
      list.add(Icon(Icons.help, color: Colors.black54,));
    }
    list.add(Expanded(child: Container()));
    list.add(Text(
        content,
        style: TextStyle(
          color: contentColor,
          fontSize: a.px16,
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

    return InkWell(
      child: view,
      onTap: onPressed,
    );
  }

  int _selectedCouponIdx = -1;
  Widget _buildCouponItemView() {
    final px12 = a.px12;
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
          fontSize: a.px18,
          fontWeight: FontWeight.w500,
        )
    ));

    list.add(Expanded(child: Container()));
    list.add(Text(
        content1,
        style: TextStyle(
          color: CustomColors.red,
          fontSize: a.px16,
          fontWeight: FontWeight.w500,
        )
    ));
    list.add(Text(
        content2,
        style: TextStyle(
          color: Colors.black87,
          fontSize: a.px16,
          fontWeight: FontWeight.w500,
        )
    ));

    list.add(
      Icon(Icons.arrow_forward_ios, color: Colors.black26, size: a.px20),
    );

    return InkWell(
      child: Container(
        color: Colors.white,
        padding: EdgeInsets.only(left: px12, right: px12, top: px12, bottom: px12),
        child: Row(
          children: list,
        ),
      ),
      onTap: () async{
        final int idx = await Utils.navigateTo(CouponSelectPage(data.coupons, _selectedCouponIdx));
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
        margin: EdgeInsets.only(left: a.px12),
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
      alert2('警戒线', '触及警戒线会被限制买入，只能卖出。请密切关注并及时追加保证金至警戒线', '知道了');
    }));
    list.add(_buildItemSplit());

    list.add(_buildItemView('止损线', '${data.cut} 元', blackColor, null, true, (){
      alert2('止损线', '当触及止损线，即会被强制平仓', '知道了');
    }));
    list.add(_buildItemSplit());

    if(data.holdTips != null){
      list.add(_buildItemView('单票持仓', data.holdTips, blackColor), );
      list.add(_buildItemSplit());
    }

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
      margin: EdgeInsets.only(top: a.px5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            '申请即表示已阅读并同意',
            style: TextStyle(
              color: Colors.black87,
              fontSize: a.px16,
            ),
          ),
          FlatButton(
            child: Text(
              '《操盘协议》',
              style: TextStyle(
                color: Colors.black87,
                fontSize: a.px16,
                fontWeight: FontWeight.w700,
              ),
            ),
            onPressed: (){
              alert('协议界面未做');
            },
          )
        ],
      ),
    );
  }

  _buildButton() {
    return Container(
      width: a.screenWidth,
      height: a.px50,
      child: RaisedButton(
        child: Text(
          '立即申请',
          style: TextStyle(color: Colors.white, fontSize: a.px18),
        ),
        onPressed: _onPressedNext,
        color: Colors.black,
      ),
    );
  }

  _onPressedNext(){
    if(data.contractType == ContractApplyDetailData.experienceType)
      _applyExperience();
    else
      _applyContract();
  }

  _applyExperience() async {
    ResultData result = await ExperienceRequest.applyContract(data.id);
    if(result.success){
      await UserRequest.getUserInfo();
      await alert('体验申请成功');
      Utils.navigatePopAll(AppTabIndex.experience);
    }
  }

  _applyContract() async {
    ResultData result = await ContractRequest.applyContract(data.type, data.times, data.loadAmount);
    if(result.success){
      if(result.data['code'] == 504){
        bool confirm = await Utils.showConfirmOptionsDialog(title: '提示', tips: '您的现金余额不足', confirmTitle: '立即充值');
        if(confirm){
          Utils.navigateTo(RechargePage());
        }
        return;
      }
      await UserRequest.getUserInfo();
      await alert('合约申请成功');
      Utils.navigatePopAll(AppTabIndex.trade);
    }
  }
}
