import 'package:flutter/material.dart';
import '../../common/constants.dart';
import '../contract_item.dart';

class CurrentContractPage extends StatefulWidget {
  @override
  _CurrentContractPageState createState() => _CurrentContractPageState();
}

class _CurrentContractPageState extends State<CurrentContractPage> {
  var _dataList;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

//    _dataList = [
//      {'type': 0, 'startPrice': 2000, 'minRate': 3, 'maxRate': 10},
//      {'type': 1, 'startPrice': 2000, 'minRate': 3, 'maxRate': 8},
//      {'type': 2, 'startPrice': 2000, 'minRate': 3, 'maxRate': 6},
//      {'type': 3, 'startPrice': 1000, 'minRate': 6, 'maxRate': 8},
//    ];
  }

  @override
  Widget build(BuildContext context) {
    final realWidth = MediaQuery.of(context).size.width;

    _dataList = [
      {'title': '免费体验', 'ongoing' : true, 'startDate': '2019-5-17', 'endDate': '2019-6-17', 'total': 6082.12, 'contract': 6000.00, 'profit': 82.12},
      {'title': '免息体验', 'ongoing' : false, 'startDate': '2019-5-14', 'endDate': '2019-5-15', 'total': 682.12, 'contract': 600.00, 'profit': 82.12},
      {'title': '天天盈', 'ongoing' : false, 'startDate': '2019-5-14', 'endDate': '2019-5-15', 'total': 682.12, 'contract': 600.00, 'profit': 82.12},
      {'title': '天天盈T+1', 'ongoing' : false, 'startDate': '2019-5-14', 'endDate': '2019-5-15', 'total': 682.12, 'contract': 600.00, 'profit': 82.12},
    ];

    return Container(
      color: CustomColors.background1,
//      child: Expanded(
        child: ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          final data = _dataList[index];
          return Container(
                padding: EdgeInsets.only(bottom: 10),
            child: ContractItemView(
              ContractType.current,
              data['title'],
              true,
              data['startDate'],
              data['endDate'],
              data['total'],
              data['contract'],
              data['profit'],
              realWidth,
            ),
            alignment: Alignment.center,
          );
        },
          itemCount: _dataList.length,
        ),
//      ),
    );
  }
}

