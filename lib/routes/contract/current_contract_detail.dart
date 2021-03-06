import 'package:flutter/material.dart';
import 'dart:math';
import 'package:funds/common/constants.dart';
import 'package:funds/common/utils.dart';
import 'package:funds/network/contract_request.dart';
import 'package:funds/network/user_request.dart';
import 'package:funds/routes/trade/stock_trade_main.dart';
import 'contract_add_capital_page.dart';
import 'contract_apply_delay_page.dart';
import 'limit_stock_list_page.dart';
import 'current_contract_withdraw_page.dart';
import 'package:funds/pages/trade/contract_flow_page.dart';

class CurrentContractDetail extends StatefulWidget {
  final ContractData data;
  CurrentContractDetail(this.data);
  @override
  _CurrentContractDetailState createState() => _CurrentContractDetailState();
}

class _CurrentContractDetailState extends State<CurrentContractDetail> {
  ContractData data;

  _refresh() async {
    ResultData result = await ContractRequest.getContractDetail(data.contractNumber);
    if(result.success && mounted){
      setState(() {
        data = result.data;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    data = widget.data;
  }

  @override
  Widget build(BuildContext context) {
    Divider divider = Divider(height: a.px20, indent: a.px18);
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text(data?.strTitle),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, size: a.px32, color: Colors.black87),
            onPressed: _refresh,
          )
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  //合约延期提示
                  _buildDelaySellTips(),
                  //资产栏
                  _buildFundsView(),
                  divider,
                  //信息栏
                  _buildInfoView(),
                  divider,
                  //图标栏
//                  Align(alignment: Alignment.centerRight, child: _buildUnderlineTextButton('今日限买股', _onPressedLimited)),
                  SizedBox(height: a.px10),
                  _buildMeterView(),
                  divider,
                  _buildWarnLineView(),
                ],
              ),
            ),
          ),
          _buildButtons(),
        ],
      ),
    );
  }

  _buildInfoView() {
    return Column(
      children: <Widget>[
        Row(children: <Widget>[
          SizedBox(width: a.px18),
          Text('合约信息', style: TextStyle(fontSize: a.px16),),
          Text('(${data.contractNumber})', style: TextStyle(fontSize: a.px12)),
          Utils.expanded(),
          _buildUnderlineTextButton('查看合约流水', _onPressedFlow),
        ]),
        _buildInfoRow(
          _buildInfoItem('杠杆本金', data.capital.toStringAsFixed(2)),
          _buildInfoItem('借款金额', data.loan.toStringAsFixed(2)),
        ),
        _buildInfoRow(
          _buildInfoItem('合约金额', data.contractMoney.toStringAsFixed(2)),
          _buildInfoItem('操盘金额', data.operateMoney.toStringAsFixed(2)),
        ),
        _buildInfoRow(
          _buildInfoItem('担保费用', data.strCost),
          _buildInfoItem('使用天数', '${data.days}个交易日'),
        ),
        _buildInfoRow(
          _buildInfoItem('利息', data.strInterest),
          _buildInfoItem('盈利分配', '${data.allocationRate}%'),
        ),
      ],
    );
  }

  _buildInfoRow(item1, item2){
    return Row(
      children: <Widget>[
        Expanded(child: item1),
        Expanded(child: item2),
      ],
    );
  }

  _buildInfoItem(title, value) {
    return Container(
      padding: EdgeInsets.only(left: a.px18, right: a.px18, top: a.px5,),
      child: Row(
        children: <Widget>[
          Text(title, style: TextStyle(fontSize: a.px16)),
          SizedBox(width: a.px8),
          Text(value, style: TextStyle(fontSize: a.px14)),
        ],
      ),
    );
  }

  _buildUnderlineTextButton(title, onPressed) {
    return Container(
        height: a.px20,
        child: FlatButton(
          child: Text(
            title,
            style: TextStyle(
              fontSize: a.px16,
              decoration: TextDecoration.underline,
            ),
          ),
          onPressed: onPressed,
        ));
  }

  _onPressedFlow() async{
    Utils.navigateTo(ContractFlowPage(widget.data));
  }

  _onPressedLimited() async{
    var result = await ContractRequest.getLimitStockList();
    if(result.success){
      Utils.navigateTo(LimitStockListPage(result.data));
    }
  }

  _onPressedWithdraw() async{
    var done = await Utils.navigateTo(CurrentContractWithdrawPage(data.contractNumber, data.cash));
    if(done == true){
      await UserRequest.getUserInfo();
      _refresh();
    }
  }

  _onPressedTrade() async {
    await Utils.navigateTo(StockTradeMainPage(data.contractNumber, data.title));
    _refresh();
  }

  _buildBottomButton({
    title,
    titleColor = Colors.black,
    bgColor = Colors.white,
    onPressed,
    icon,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        border: Border.all(color: Colors.grey, width: 0.5),
      ),
      child: FlatButton(
        child: Text(
          title,
          style: TextStyle(fontSize: a.px18, color: titleColor),
        ),
        onPressed: onPressed,
      ),
    );
  }

  _buildMoreButton() {
    final buttonView = Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey, width: 0.5),
      ),
      child: FlatButton(
        onPressed: null,
        child: Row(
          children: <Widget>[
            Icon(
              Icons.menu,
              color: Colors.black,
              size: a.px20,
            ),
            Text(
              '更多操作',
              style: TextStyle(fontSize: a.px18, color: Colors.black),
            ),
          ],
        ),
      )
    );

    buildMenuItem(title, value) {
      return PopupMenuItem<int>(
        child: Text(
          title,
          textAlign: TextAlign.center,
        ),
        value: value,
      );
    }

    List<PopupMenuItem<int>> menuItems = [
      buildMenuItem('追加本金', ContractOperate.addMoney),
      buildMenuItem('申请结算', ContractOperate.applySettlement),
//      buildMenuItem('申请停牌回收', ContractOperate.applySuspendedCycle),
    ];

    if(data.canDelay)
      menuItems.insert(2, buildMenuItem('延期卖出', ContractOperate.delaySell));

    return PopupMenuButton<int>(
      child: buttonView,
      itemBuilder: (builder) => menuItems,
      onSelected: (value) async{
        switch(value){
          case ContractOperate.addMoney:
            double minAdd = (data.operateMoney * 0.01 * 100).round() / 100;
            await UserRequest.getUserInfo();
            var success = await Utils.navigateTo(ContractAddCapitalPage(data.contractNumber, minAdd));
            if(success == true)
              _refresh();
            break;

          case ContractOperate.applySettlement:
            if(await Utils.showConfirmOptionsDialog(tips: '提前终止不退还已收担保费和利息，确认结算当前合约？')){
              ResultData result = await ContractRequest.applySettlement(data.contractNumber);
              if(result.success){
                await alert('申请结算成功');
                Utils.navigatePop();
              }
            }
            break;

          case ContractOperate.delaySell:
            _onPressedApplyDelaySell();
            break;

          case ContractOperate.applySuspendedCycle:
            _onApplySuspendedCycle();
            break;

        }
      },
    );
  }

  _buildWarnLineView() {
    return Container(
      padding:
      EdgeInsets.symmetric(horizontal: a.px42),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text('警戒线：${data?.cordon ?? 0}', style: TextStyle(fontSize: a.px16)),
          Text('止损线：${data?.cut ?? 0}', style: TextStyle(fontSize: a.px16)),
        ],
      ),
    );
  }

  _buildFundsItem(title, value, valueFontSize,
      [percent, onPressed, color]) {
    Widget titleText;
    if (onPressed != null) {
      titleText = Row(
        children: <Widget>[
          Text(title, style: TextStyle(fontSize: a.px15, color: Colors.black87)),
          SizedBox(width: a.px5),
          InkWell(
            child: Icon(Icons.help, size: a.px20,),
            onTap: onPressed,
          )
        ],
      );
    } else {
      titleText = Text(title, style: TextStyle(fontSize: a.px15, color: Colors.black87));
    }

//    String strValue = ivalue
    List<Widget> children = [
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          titleText,
          SizedBox(height: a.px5),
          Text(
            value.toStringAsFixed(2),
            style: TextStyle(
                fontSize: valueFontSize,
                color: color ?? Utils.getProfitColor(value),
                fontWeight: FontWeight.w700
            ),
          ),
        ],
      ),
      Expanded(child: Container()),
      SizedBox(width: a.px16),
    ];
    if (onPressed != null)
      children.add(Container(
        height: 30,
        width: 1,
        color: Colors.white30,
      ));

    return Container(
      child: Row(
        children: children,
      ),
    );
  }

  _buildProfitItem() {
    Widget titleText = Row(
      children: <Widget>[
        Text('累计盈亏', style: TextStyle(fontSize: a.px15, color: Colors.black87)),
        SizedBox(width: a.px5),
        InkWell(
          child: Icon(Icons.help, size: a.px20,),
          onTap: () {
            alert2('累计盈亏', '累计盈亏=当前盈亏+已提盈利', '知道了');
          },
        )
      ],
    );

//
//    List<Widget> children = [
//      Column(
//        crossAxisAlignment: CrossAxisAlignment.start,
//        children: <Widget>[
//          titleText,
//          SizedBox(height: a.px5),
//          Text(
//            data.strProfit,
//            style: TextStyle(
//                fontSize: a.px18,
//                color: Utils.getProfitColor(data.profit),
//                fontWeight: FontWeight.w700
//            ),
//          ),
//        ],
//      ),
////      Expanded(child: Container()),
////      SizedBox(width: a.px16),
////      Container(
////        height: 30,
////        width: 1,
////        color: Colors.white30,
////      )
//    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        titleText,
        SizedBox(height: a.px5),
        Text(
          data?.strProfit ?? '',
          style: TextStyle(
              fontSize: a.px18,
              color: Utils.getProfitColor(data.profit),
              fontWeight: FontWeight.w700
          ),
        ),
      ],
    );
  }

  _buildFundsView() {
    return Container(
      margin: EdgeInsets.only(
          left: a.px30, top: a.px20),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: _buildFundsItem('资产总值', data.totalMoney, a.px25),
              ),
              Expanded(
                child: _buildFundsItem(
                  '可提盈利',
                  data?.cash ?? 0,
                  a.px25,
                  null,
                      () {
                    alert2('可提盈利', '可提现金=非杠杆现金+当前盈亏，盘后可提取', '知道了');
                  },
                ),
              ),
            ],
          ),
          SizedBox(height: a.px8),
          _buildProfitItem(),
        ],
      ),
    );
  }

  _buildDelaySellTips() {
    if(!data.canDelay || data.leftDays > 1){
      return Container();
    }

    double fontSize = a.px15;
    return Container(
      padding: EdgeInsets.only(left: a.px16),
      color: Color(0xFFFEEEC0),
      child: Row(
        children: <Widget>[
          Icon(Icons.info, size: a.px22, color: CustomColors.red),
          SizedBox(width: a.px6,),
          Text('当前合约于今日到期，', style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.w500)),
          FlatButton(
            child: Text(
              '点击申请延期卖出',
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.w500,
                decoration: TextDecoration.underline,
              ),
            ),
            onPressed: _onPressedApplyDelaySell,
          ),
          Text('>>', style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  _getRotateAngle() {
    if (data == null) return 0.0;
    //根据图片pi*0.3角度为警戒线到止损线之间的角度差
    double unit = pi * 0.3 / (data.cordon - data.cut);
    double angle = (data.totalMoney - data.cordon) * unit;

    //根据图片，旋转左边最小值为-1.4，右边最大值为1.35
    angle = max(angle, -1.4);
    angle = min(angle, 1.35);

    return angle;
  }

  _buildMeterView() {
    final double width = MediaQuery.of(context).size.width;
    return Stack(
      children: <Widget>[
        Image.asset(CustomIcons.meter, width: width),
        Positioned(
          left: width * 0.5,
          bottom: 0,
          child: Transform.rotate(
            angle: _getRotateAngle(),
            alignment: Alignment.bottomCenter,
            child: Image.asset(
              CustomIcons.meterArrow,
              height: width * 0.34,
            ),
          ),
        ),
      ],
    );
  }

  _buildButtons(){
    List<Widget> buttons = [
      Expanded(child: _buildMoreButton()),
    ];

    Widget btnTrade = _buildBottomButton(title: '委托交易', titleColor: Colors.white, bgColor: Colors.black,onPressed: _onPressedTrade);
    if(data.cash > 0){
      buttons.add(Expanded(child: _buildBottomButton(title: '提取现金', onPressed: _onPressedWithdraw),));
      buttons.add(Expanded(child: btnTrade));
    }else{
      buttons.add(Expanded(flex: 2, child: btnTrade));
    }
    return Row(children: buttons);
  }

  _onPressedApplyDelaySell() async{
//    return;
    var result = await ContractRequest.getDelayData(data.contractNumber);
    if(!result.success)
      return;

    var delay = await Utils.navigateTo(ContractApplyDelayPage(data, result.data));
//    var delay = await Utils.navigateTo(ContractApplyDelayPage(data, ContractDelayData.fromTest(3.18, 5, '2019-07-08')));
    if(delay == true){
      _refresh();
    }
  }

  _onApplySuspendedCycle() async{
    if(!await Utils.showConfirmOptionsDialog(tips: '是否确定申请停牌回收？'))
      return;

    var result = await ContractRequest.applySuspendedCycle(data.contractNumber);
    if(result.success){
      alert('申请成功，请等待审核');
    }
  }
}
