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
                _buildProfitRateView(),
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
    double profitRate = data.profit / data.capital;
//    profitRate = -0.9691;
    final double width = a.px(220);
    final double arcWidth = a.px(199);
    final double arcOffset = (width - arcWidth) * 0.5;
    final progress = profitRate / 2;//收益200%时满格
    return Container(
      padding: EdgeInsets.symmetric(vertical: a.px20),
      alignment: Alignment.center,
      color: Colors.white,
      child: Stack(
        children: <Widget>[
          Container(
            height: width,
            width: width,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(CustomIcons.profitRateTray),
                fit: BoxFit.fitHeight,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text('盈亏比例', style: TextStyle(fontSize: a.px15, fontWeight: FontWeight.w700),),
                SizedBox(height: a.px10,),
                Text('${(profitRate * 100).toStringAsFixed(2)}%', style: TextStyle(fontSize: a.px22, fontWeight: FontWeight.w500, color: Utils.getProfitColor(profitRate)),),
                SizedBox(height: a.px20,),

              ],
            ),
          ),
          Positioned(
            left: arcOffset - a.px(2.3),//图片歪，需微调
            top: arcOffset + a.px(0.5),
            child: CustomPaint(
              size: Size(arcWidth, arcWidth),
              painter: ProgressPainter(
                width: a.px4,
                color: Colors.orange,
                progress: progress,
              ),
            ),
          ),
        ],
      )
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

class ProgressPainter extends CustomPainter {
  final double width;
  final Color color;
  final double progress;

  ProgressPainter({
    @required this.width,
    @required this.color,
    @required this.progress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double center = size.width * 0.5;
    final Offset offsetCenter = Offset(center, center);
    final double drawRadius = size.width * 0.5 - width;
    final double radians = pi * 2 * progress;
    final double radiusOffset = width * 0.4;
    final double outerRadius = center - radiusOffset;
    final double innerRadius = center - width * 2 + radiusOffset;

    if (progress > 0.0) {
      final progressWidth = outerRadius - innerRadius + radiusOffset;
      final double offset = asin(progressWidth * 0.5 / drawRadius);
      if (radians > offset) {
        canvas.save();
        canvas.translate(0.0, size.width);
        canvas.rotate(-pi * 0.5);//degToRad(-90.0)
        final Rect arcRect = Rect.fromCircle(center: offsetCenter, radius: drawRadius);
        final progressPaint = Paint()
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round
          ..strokeWidth = progressWidth
          ..color = color;
        canvas.drawArc(arcRect, offset, radians - offset, false, progressPaint);
        canvas.restore();
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}