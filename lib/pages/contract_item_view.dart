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
  final double realWidth;
  final ContractData data;
  final onPressed;

  Color totalColor;
  Color profitValueColor;
  String profitTitle;
  ContractItemView(this.data, this.realWidth, this.onPressed){
    switch(data.type){
      case ContractType.trial:
        totalColor = Colors.black;
        profitValueColor = CustomColors.red;
        profitTitle = '累计盈亏';
        break;

      case ContractType.current:
        totalColor = CustomColors.red;;
        profitValueColor = Colors.black;
        profitTitle = '可提现金';
        break;

      case ContractType.history:
        totalColor = Colors.black;
        profitValueColor = Utils.getProfitColor(data.profit);
        profitTitle = '结算退还';
        break;

    }
  }

  _stateView() {
    final String text = data.ongoing ? '操盘中' : '已结束';
    final Color color = data.ongoing ? CustomColors.red : Colors.grey;
    return Container(
      width: adapt(50, realWidth),
      height: adapt(22, realWidth),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.all(Radius.circular(adapt(10, realWidth))),
      ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            fontSize: adapt(13, realWidth),
            color: Colors.white,
          ),
        ),
      ),
    );
//    return Chip(
//      backgroundColor: color,
//      label: Text(text),
//    );
  }

  _dateView() {
    String text = '${data.startDate} 至 ${data.endDate}';
    return Text(
        text,
        style: TextStyle(
          fontSize: adapt(13, realWidth),
          color: Colors.black54,
        ),
    );
  }

  Widget _buildRow1() {
    final px6 = adapt(6, realWidth);
    final px16 = adapt(16, realWidth);
    return Container(
//      width: double.infinity,
//      height: 10,
      child: Row(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(left: px16),
            child: Text(
              '资产总值',
              style: TextStyle(
                fontSize: px16,
                color: Color(0xBF000000),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: px6),
            child: Text(
              '${data.total}',
              style: TextStyle(
                fontSize: px16,
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
            margin: EdgeInsets.only(left: adapt(16, realWidth)),
            child: Text('合约金额',
                style: TextStyle(
                  fontSize: adapt(16, realWidth),
                  color: Color(0xBF000000),
                )),
          ),
          Container(
            margin: EdgeInsets.only(left: adapt(6, realWidth)),
            child: Text(data.contract.toString(),
                style: TextStyle(
                  fontSize: adapt(16, realWidth),
                  color: Colors.black,
                )),
          ),
        ],
      ),
    );
  }

  Widget _buildRow3() {
    final px6 = adapt(6, realWidth);
    final px16 = adapt(16, realWidth);
    return Container(
//      width: 150,
      child: Row(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(left: px16, right: px6),
            child:
            Text(
              profitTitle, 
              style: TextStyle(
                fontSize: px16,
                color: Color(0xBF000000),
              ),
            ),
          ),
          Container(
            child: Text(
              data.profit.toString(),
              style: TextStyle(
                fontSize: px16,
                color: profitValueColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  createView() {
    final px1 = adapt(1, realWidth);
    final px6 = adapt(6, realWidth);
    final px10 = adapt(10, realWidth);
    final px16 = adapt(16, realWidth);
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(top: px10, bottom: px10),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(left: px16, right: px6),
                child: Text(
                  data.title,
                  style: TextStyle(
                    fontSize: px16,
                    color: Colors.black,
                    ),
                ),
              ),
              _stateView(),
              Expanded(
                child: Container(),
              ),
              Container(
                margin: EdgeInsets.only(left: px16, right: px16),
                child: _dateView(),
              ),
            ],
          ),
          Container(
            height: px1,
            margin: EdgeInsets.only(left: px10, top: px10, bottom: px10),
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
          SizedBox(height: px6),
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
