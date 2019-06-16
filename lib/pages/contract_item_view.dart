import 'package:flutter/material.dart';
import 'package:funds/common/constants.dart';
import 'package:funds/model/contract_data.dart';
import 'package:funds/common/utils.dart';

class ContractItemView extends StatelessWidget {
//  final int type;
//  final String title;
//  final bool ongoing;
//  final String startDate;
//  final String endDate;
//  final double total;
//  final double contract;
//  final double profit;
//  final double realWidth;
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
        profitTitle = '可提现金';
        profitValue = data.cash.toStringAsFixed(2);
        break;

      case ContractType.history:
        totalColor = Colors.black;
        profitValueColor = Utils.getProfitColor(data.returnMoney);
        profitTitle = '结算退还';
        profitValue = data.returnMoney.toStringAsFixed(2);
        break;

    }
  }

  _titleView() {
    return Container(
      margin: EdgeInsets.only(left: a.px16, right: a.px6),
      child: Text(
        data.title,
        style: TextStyle(
          fontSize: a.px16,
          color: Colors.black,
        ),
      ),
    );
  }

  _stateView() {
    final String text = data.ongoing ? '操盘中' : '已结束';
    final Color color = data.ongoing ? CustomColors.red : Colors.grey;
    return Container(
      width: a.px50,
      height: a.px22,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.all(Radius.circular(a.px10)),
      ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            fontSize: a.px13,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  _dateView() {
    String text = '${data.beginTime} 至 ${data.endTime}';
    return Container(
      margin: EdgeInsets.only(left: a.px16, right: a.px16),
      child: Text(
        text,
        style: TextStyle(
          fontSize: a.px13,
          color: Colors.black54,
        ),
      ),
    );
  }

  Widget _buildRow1() {
    return Container(
      child: Row(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(left: a.px16),
            child: Text(
              '资产总值',
              style: TextStyle(
                fontSize: a.px16,
                color: Color(0xBF000000),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: a.px6),
            child: Text(
              '${data.totalMoney}',
              style: TextStyle(
                fontSize: a.px16,
                color: totalColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRow2() {
    return Container(
//      width: 150,
      child: Row(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(left: a.px16),
            child: Text('合约金额',
                style: TextStyle(
                  fontSize: a.px16,
                  color: Color(0xBF000000),
                )),
          ),
          Container(
            margin: EdgeInsets.only(left: a.px6),
            child: Text(data.contractMoney.toStringAsFixed(2),
                style: TextStyle(
                  fontSize: a.px16,
                  color: Colors.black,
                )),
          ),
        ],
      ),
    );
  }

  Widget _buildRow3() {
    return Container(
      child: Row(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(left: a.px16, right: a.px6),
            child:
            Text(
              profitTitle, 
              style: TextStyle(
                fontSize: a.px16,
                color: Color(0xBF000000),
              ),
            ),
          ),
          Container(
            child: Text(
              profitValue,
              style: TextStyle(
                fontSize: a.px16,
                color: profitValueColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  createView() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(top: a.px10, bottom: a.px10),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              _titleView(),
              _stateView(),
              Expanded(child: Container(),),
              _dateView(),
            ],
          ),
          Container(
            height: a.px1,
            margin: EdgeInsets.only(left: a.px10, top: a.px10, bottom: a.px10),
            color: CustomColors.background1,
          ),
          Table(
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            children: <TableRow>[
              TableRow(
                children: <Widget>[
                  _buildRow1(),
                  _buildRow2(),
                ],
              ),
            ],
          ),
          SizedBox(height: a.px6),
          _buildRow3()
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: createView(),
      onTap: onPressed,
    );
  }
}
