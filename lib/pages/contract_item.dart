import 'package:flutter/material.dart';
import '../common/constants.dart';

class ContractItemView extends StatelessWidget {
  final int type;
  final String title;
  final bool ongoing;
  final String startDate;
  final String endDate;
  final double total;
  final double contract;
  final double profit;

  Color totalColor;
  Color profitValueColor;
  String profitTitle;
  ContractItemView(this.type, this.title, this.ongoing, this.startDate, this.endDate,
      this.total, this.contract, this.profit){
    switch(type){
      case ContractType.trial:
        totalColor = Colors.black;
        profitValueColor = CustomColors.red;
        profitTitle = '累计盈亏';
        break;

      case ContractType.current:
        totalColor = Colors.black;
        profitValueColor = CustomColors.red;
        profitTitle = '可提现金';
        break;

      case ContractType.history:
        totalColor = CustomColors.red;
        profitValueColor = Colors.black;
        profitTitle = '结算退还';
        break;

    }
  }

  getTitle(type) {
    return type == 0 ? '免费体验' : '免息体验';
  }

  _stateView() {
    final String text = ongoing ? '操盘中' : '已结束';
    final Color color = ongoing ? CustomColors.red : Colors.grey;
    return Container(
      width: 50,
      height: 22,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ),
      child: Center(
        child: Text(text, style: CustomStyles.trialItemStateStyle),
      ),
    );
  }

  _dateView() {
    String text = '$startDate 至 $endDate';
    return Text(text, style: CustomStyles.trialItemDateStyle);
  }

  Widget _buildRow1() {
    return Container(
//      width: double.infinity,
//      height: 10,
      child: Row(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(left: 16),
            child: Text('资产总值',
                style: CustomStyles.trialItemNormalTextStyle),
          ),
          Container(
            margin: EdgeInsets.only(left: 6),
            child: Text(
              '$total',
              style: TextStyle(
                fontSize: 16,
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
            margin: EdgeInsets.only(left: 16),
            child: Text('合约金额',
                style: CustomStyles.trialItemNormalTextStyle),
          ),
          Container(
            margin: EdgeInsets.only(left: 6),
            child: Text('$contract',
                style: CustomStyles.trialItemTitleStyle),
          ),
        ],
      ),
    );
  }

  Widget _buildRow3() {
    return Container(
//      width: 150,
      child: Row(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(left: 16, right: 6),
            child:
            Text(profitTitle, style: CustomStyles.trialItemNormalTextStyle),
          ),
          Container(
            child: Text(
              '$profit',
              style: TextStyle(
                fontSize: 16,
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
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(left: 16, right: 6),
                child: Text(title, style: CustomStyles.trialItemTitleStyle),
              ),
              _stateView(),
              Expanded(
                child: Container(),
              ),
              Container(
                margin: EdgeInsets.only(left: 16, right: 16),
                child: _dateView(),
              ),
            ],
          ),
          Container(
            height: 1,
            margin: EdgeInsets.only(left: 10, top: 10, bottom: 10),
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
          SizedBox(height: 5),
          _buildRow3()
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: createView(),
      onTap: () {
        print('press contract');
      },
    );
  }
}
