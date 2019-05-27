import 'package:flutter/material.dart';
import '../../common/constants.dart';

class MyTrialPage extends StatefulWidget {
  @override
  _MyTrialPageState createState() => _MyTrialPageState();
}

class _MyTrialPageState extends State<MyTrialPage> {
  var _dataList;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _dataList = [
      {'type': 0, 'ongoing' : true, 'startDate': '2019-5-17', 'endDate': '2019-6-17', 'total': 6082.12, 'contract': 6000.00, 'profit': 82.12},
      {'type': 1, 'ongoing' : false, 'startDate': '2019-5-14', 'endDate': '2019-5-15', 'total': 682.12, 'contract': 600.00, 'profit': 82.12},
    ];
//    _dataList = [
//      {'type': 0, 'startPrice': 2000, 'minRate': 3, 'maxRate': 10},
//      {'type': 1, 'startPrice': 2000, 'minRate': 3, 'maxRate': 8},
//      {'type': 2, 'startPrice': 2000, 'minRate': 3, 'maxRate': 6},
//      {'type': 3, 'startPrice': 1000, 'minRate': 6, 'maxRate': 8},
//    ];
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          final data = _dataList[index];
          return Container(
            padding: EdgeInsets.only(bottom: 10),
            child: _ItemView(
              data['type'],
              data['ongoing'],
              data['startDate'],
              data['endDate'],
              data['total'],
              data['contract'],
              data['profit'],
            ),
            alignment: Alignment.center,
          );
        },
        itemCount: _dataList.length,
      ),
    );
  }
}

class _ItemView extends StatelessWidget {
  final int type;
  final bool ongoing;
  final String startDate;
  final String endDate;
  final double total;
  final double contract;
  final double profit;
  _ItemView(
      this.type,
      this.ongoing,
      this.startDate,
      this.endDate,
      this.total,
      this.contract,
      this.profit
      );

  getTitle(type) {
    return type == 0 ? '免费体验' : '免息体验';
  }

  _stateView() {
    final String text = ongoing ? '操盘中' : '已结束';
    final Color color = ongoing ? CustomColors.red: Colors.grey;
    return Container(
      width: 50,
      height: 22,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ),
//      padding: const EdgeInsets.only(right: 10, bottom: 10.0),
      child: Center(
        child: Text(text, style: CustomStyles.trialItemStateStyle),
      ),
    );
  }

  _dateView() {
    String text = '$startDate 至 $endDate';
    return Text(text, style: CustomStyles.trialItemDateStyle);
  }

  createView () {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.only(top:10, bottom: 10),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(left: 16, right: 6),
                child: Text(getTitle(type), style: CustomStyles.trialItemTitleStyle),
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
            color: CustomColors.homeBackground,
          ),

          Row(
//            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Container(
                width: 150,
                child: Row(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(left: 16),
                      child: Text('资产总值', style: CustomStyles.trialItemNormalTextStyle),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 6),
                      child: Text('$total', style: CustomStyles.trialItemTitleStyle),
                    ),
                  ],
                ),
              ),

//              Container(width: 30),
              const SizedBox(width: 30),

              Row(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(left: 16),
                    child: Text('合约金额', style: CustomStyles.trialItemNormalTextStyle),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 6),
                    child: Text('$contract', style: CustomStyles.trialItemTitleStyle),
                  ),
                ],
              ),
            ],
          ),

          Row(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(left: 16, right: 6),
                child: Text('累计盈亏', style: CustomStyles.trialItemNormalTextStyle),
              ),
              Container(
                child: Text('$profit', style: CustomStyles.trialItemProfitStyle),
              ),
            ],
          ),
        ],
      ),
    );

  }

  @override
  Widget build(BuildContext context) {
    print('item view type:$type');
    return GestureDetector(
      child: createView(),
      onTap: () {
        print('press item type:$type');
      },
    );
  }
}