import 'package:flutter/material.dart';
import '../../common/constants.dart';
import '../contract_item.dart';

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
      {'title':'免费体验', 'ongoing' : true, 'startDate': '2019-5-17', 'endDate': '2019-6-17', 'total': 6082.12, 'contract': 6000.00, 'profit': 82.12},
      {'title':'免息体验', 'ongoing' : false, 'startDate': '2019-5-14', 'endDate': '2019-5-15', 'total': 682.12, 'contract': 600.00, 'profit': 82.12},
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
    final realWidth = MediaQuery.of(context).size.width;
    return Expanded(
      child: ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          final data = _dataList[index];
          return Container(
            margin: EdgeInsets.only(top: adapt(10, realWidth)),
//            padding: EdgeInsets.only(bottom: 10),
            child: ContractItemView(
              ContractType.trial,
              data['title'],
              data['ongoing'],
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
    );
  }
}
