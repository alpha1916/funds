import 'package:flutter/material.dart';
import 'package:funds/common/constants.dart';
import 'package:funds/common/utils.dart';
import 'package:funds/network/contract_request.dart';
import 'trade_flow_page.dart';
import 'dart:ui';
import 'dart:math';


class HistoryTrialDetail extends StatelessWidget {
  final ContractData data;
  HistoryTrialDetail(this.data);
  final EdgeInsetsGeometry _itemPadding = EdgeInsets.symmetric(vertical: a.px16, horizontal: a.px16);
  final Widget _splitLine = Divider(height: 0, indent: a.px16);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(data.title),
      ),
      body: Column(
        children: <Widget>[
          SingleChildScrollView(
            child: Column(
              children: <Widget>[
                _buildTitleView(),
                _splitLine,
                Container(height: a.px20, color: Colors.white,),
                _buildProfitRateView(),
                Container(height: a.px20, color: Colors.white,),
                _splitLine,
                _buildCostItem('累计盈亏', data.profit, Utils.getProfitColor(data.profit)),
                _splitLine,
                _buildCostItem('杠杆本金', data.capital),
                _splitLine,
                _buildContractMoneyView(),
                _splitLine,
                SizedBox(height: a.px10,),
                _buildClickableItem('查看历史交易', _onPressTradeHistory),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _buildProfitRateView() {
//    final String profitRate = (data.profit / data.capital).toStringAsFixed(2) + '%';
    final String profitRate = '16.91%';
    return Container(
      height: a.px(220),
      width: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(CustomIcons.profitRateTray),
          fit: BoxFit.fitHeight,
        ),
        color: Colors.white,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text('盈亏比例', style: TextStyle(fontSize: a.px15, fontWeight: FontWeight.w700),),
          SizedBox(height: a.px10,),
          Text(profitRate, style: TextStyle(fontSize: a.px22, fontWeight: FontWeight.w500, color: Utils.getProfitColor(1)),),
          SizedBox(height: a.px20,),
        ],
      ),
    );
  }

  _buildBalanceTextView() {
    return Container(
      alignment: Alignment.center,
      width: a.px48,
      height: a.px18,
      decoration: BoxDecoration(
        color: Color(0xAA000000),
        borderRadius: BorderRadius.all(Radius.circular(a.px5)),
      ),
      child: Text('已结算', style: TextStyle(fontSize: a.px12, color: Colors.white)),
    );
  }

  _buildTitleView() {
    String strDate = '${data.beginTime} 至 ${data.endTime}';
    return Container(
      color: Colors.white,
      padding: _itemPadding,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(data.title, style: TextStyle(fontSize: a.px16, color: Colors.black)),
          Text(strDate, style: TextStyle(fontSize: a.px13, color: Colors.black54),
          ),
        ],
      ),
    );
  }

  _buildCostItem(String title, double cost, [Color color]){
    return Container(
      color: Colors.white,
      padding: _itemPadding,
      child: Row(
        children: <Widget>[
          Text(title, style: TextStyle(fontSize: a.px16, color: Colors.black,fontWeight: FontWeight.w500)),
          SizedBox(width: a.px16),
          _buildBalanceTextView(),
          Utils.expanded(),
          Text(cost.toStringAsFixed(2), style: TextStyle(fontSize: a.px16, color: color, fontWeight: FontWeight.w500)),
          Text(' 元', style: TextStyle(fontSize: a.px16, fontWeight: FontWeight.w500),),
        ],
      ),
    );
  }
  num degToRad(num deg) => deg * (pi / 180.0);
  num radToDeg(num rad) => rad * (180.0 / pi);

  _buildRingProgressView(){
    double progress = 0.15;
    final angle = 360.0 * progress;
    final Offset offsetCenter = Offset(150, 150);
    final double radians = degToRad(angle);
    final Rect arcRect = Rect.fromCircle(center: offsetCenter, radius: 150);
    final progressPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 20;
    canvas.drawArc(arcRect, 0.0, degToRad(angle), false, progressPaint);
    return CustomPaint(
      painter: progressPaint,
    );
  }

  _buildContractMoneyView(){
    return Container(
      color: Colors.white,
      padding: _itemPadding,
      child: Row(
        children: <Widget>[
          Text('合约金额', style: TextStyle(fontSize: a.px16, color: Colors.black,fontWeight: FontWeight.w500)),
          Utils.expanded(),
          Text(data.contractMoney.toStringAsFixed(2), style: TextStyle(fontSize: a.px16, fontWeight: FontWeight.w500),),
          Text(' 元', style: TextStyle(fontSize: a.px16, fontWeight: FontWeight.w500),),
        ],
      ),
    );
  }

  _buildClickableItem(title , onPressed) {
    return InkWell(
      child: Container(
        padding: _itemPadding,
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(title, style: TextStyle(fontSize: a.px16, color: Colors.black,fontWeight: FontWeight.w500)),
            Utils.buildForwardIcon(),
          ],
        ),
      ),
      onTap: onPressed,
    );
  }

  _onPressTradeHistory() async{
    ResultData result = await ContractRequest.getTradeFlowList(data.contractNumber);
    if(result.success)
      Utils.navigateTo(TradeFlowPage('交易流水', StateType.deal, result.data));
  }
}

