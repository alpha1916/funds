import 'package:flutter/material.dart';
import 'package:funds/common/constants.dart';
import 'package:funds/model/contract_data.dart';
import 'package:funds/common/utils.dart';

class ContractItemView extends StatelessWidget {
  final int type;
  final ContractData data;
  final onPressed;

  Color totalColor;
  Color profitValueColor;
  String profitTitle;
  String profitValue;
  ContractItemView(this.type, this.data, this.onPressed){
    switch(type){
      case ContractType.trial:
        totalColor = Colors.black;
        profitValueColor = CustomColors.red;
        profitTitle = '累计盈亏';
        profitValue = data.profit.toStringAsFixed(2);
        break;

      case ContractType.current:
        totalColor = CustomColors.red;;
        profitValueColor = Colors.black;
        profitTitle = '可提盈利';
        profitValue = data.cash.toStringAsFixed(2);
        break;

      case ContractType.history:
        totalColor = Colors.black;
        profitValueColor = Utils.getProfitColor(data.returnMoney);
        profitTitle = '结算退还';
        profitValue = data.returnMoney.toStringAsFixed(2);
        break;

    }
    profitTitle += '  ';
  }

  _titleView() {
    return Text(data.strTitle, style: TextStyle(fontSize: a.px18, color: Colors.black, fontWeight: FontWeight.w500));
  }

  _stateView() {
    final String text = data.strState;//data.ongoing ? '操盘中' : '已结束';
    Color color;//data.ongoing ? CustomColors.red : Colors.grey;
    switch(data.state){
      case 1:
        color = CustomColors.red;
        break;

      case 2:
        color = Colors.grey;
        break;

      default:
        color = Colors.green;
        break;
    }

    return Container(
      alignment: Alignment.center,
      width: a.px(64),
      height: a.px22,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.all(Radius.circular(a.px10)),
      ),
      child: Text(text, style: TextStyle(fontSize: a.px13, color: Colors.white)),
    );
  }

  _dateView() {
    return Text('${data.beginTime} 至 ${data.endTime}', style: TextStyle(fontSize: a.px13, color: Colors.black54));
  }

  _contractNumberView() {
    return Text('合约号 : ${data.contractNumber}', style: TextStyle(fontSize: a.px13, color: Colors.black54));
  }

  Widget _buildRow1() {
    return Expanded(
      child: Row(
        children: <Widget>[
          Text('资产总值  ', style: TextStyle(fontSize: a.px16, color: Color(0xBF000000))),
          Text('${data.totalMoney}', style: TextStyle(fontSize: a.px16, color: totalColor)),
        ],
      ),
    );
  }

  Widget _buildRow2() {
    return Expanded(
      child: Row(
        children: <Widget>[
          Text('累计盈亏  ', style: TextStyle(fontSize: a.px16, color: Color(0xBF000000))),
          Text(data.profit.toStringAsFixed(2), style: TextStyle(fontSize: a.px16, color: Utils.getProfitColor(data.profit),)),
        ],
      ),
    );
  }

  Widget _buildRow3() {
    return Expanded(
      child: Row(
        children: <Widget>[
          Text(profitTitle, style: TextStyle(fontSize: a.px16, color: Color(0xBF000000))),
          Text(profitValue, style: TextStyle(fontSize: a.px16, color: profitValueColor)),
        ],
      )
    );
  }

  Widget _buildRow4() {
    return Expanded(
        child: Row(
          children: <Widget>[
            Text('盈亏比例  ', style: TextStyle(fontSize: a.px16, color: Color(0xBF000000))),
            Text('${data.strProfitRate}', style: TextStyle(fontSize: a.px16, color: Utils.getProfitColor(data.profit)),),
          ],
        )
    );
  }

  createView() {
    return Container(
      color: Colors.white,
      child: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(left: a.px16, right: a.px16, top: a.px10),
                child: Row(
                  children: <Widget>[
                    _titleView(),
                    SizedBox(width: a.px10),
                    _stateView(),
                    Utils.expanded(),
                    _contractNumberView(),
                  ],
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(left: a.px16, right: a.px16, top: a.px10, bottom: a.px10),
                child: _dateView(),
              ),
              Divider(height: a.px1, indent: a.px16),
              Container(
                padding: EdgeInsets.only(left: a.px16, right: a.px16, top: a.px10, bottom: a.px10),
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        _buildRow1(),
                        _buildRow2(),
                      ],
                    ),
                    SizedBox(height: a.px6),
                    Row(
                      children: <Widget>[
                        _buildRow3(),
                        _buildRow4(),
                      ],
                    ),
//                    _buildRow3()

                  ],
                ),
              ),
            ],
          ),
          _buildExpireView(),
        ],
      ),
    );
  }

  _buildExpireView(){
    if(data.leftDays != 1 || !data.ongoing)
      return Container();

    return Positioned(
      bottom: 0,
      right: a.px10,
      child: Image.asset(
        CustomIcons.expire,
        width: a.px50,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: createView(),
      onTap: onPressed,
    );
  }
}
