import 'package:flutter/material.dart';
import 'package:funds/common/constants.dart';
import 'package:funds/common/utils.dart';

class TradeConfirmDialog extends StatelessWidget {
  final int type;
  final data;
  TradeConfirmDialog(this.type, this.data);

  @override
  Widget build(BuildContext context) {
    String strType = type == TradeType.buy ? '买入' : '卖出';
    String title = '委托$strType确认';
    String btnTitle = '确认$strType';
    Color colorType = type == TradeType.buy ? CustomColors.red : Colors.green;
    return Container(
      alignment: Alignment.center,
      width: a.px(360),
      height: a.px(286),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(a.px12)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(left: a.px16, top: a.px16, bottom: a.px8),
            alignment: Alignment.centerLeft,
            child: Text(title, style: TextStyle(fontSize: a.px20, fontWeight: FontWeight.w400, color: Colors.black),),
          ),
          _buildColumnItem('股票代码', data['code']),
          _buildColumnItem('股票名称', data['title']),
          Divider(height: 0, indent: a.px16),
          _buildColumnItem('委托价格', data['price'].toStringAsFixed(2), colorType),
          _buildColumnItem('委托数量', '${data['count']}股', colorType),
          Divider(height: 0,),
          _buildConfirmButton(btnTitle),
        ],
      ),
    );
  }

  _buildColumnItem(leftText, rightText, [color = Colors.black]){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: a.px16, vertical: a.px6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(leftText, style: TextStyle(fontSize: a.px16),),
          Text(rightText, style: TextStyle(fontSize: a.px16, color: color),),
        ],
      ),
    );
  }

  _buildConfirmButton(btnTitle) {
    return InkWell(
      child:Container(
        margin: EdgeInsets.symmetric(vertical: a.px12),
        color: Colors.transparent,
        child: Center(
          child: Text(btnTitle, style: TextStyle(fontSize: a.px22, color: Color(0xFFF48C33)),),
        ),
      ),
      onTap: () => Utils.navigatePop(true),
    );
  }
}
